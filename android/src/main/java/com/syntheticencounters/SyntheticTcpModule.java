package com.syntheticencounters;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;

import static java.lang.Thread.sleep;

public class SyntheticTcpModule extends ReactContextBaseJavaModule {

    private Socket socket;
    private PrintWriter writer;
    private BufferedReader reader;
    private final ReactApplicationContext reactContext;

    public SyntheticTcpModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;

    }

    @Override
    public String getName() {
        return "SyntheticTcp";
    }

    @ReactMethod
    public void connect(String host, int port, int timeout, Callback callback) {

        // timeout not used for android but needed for method consistency across applications
        if(host == null) {
            callback.invoke("Missing required host and/or port", null);
            return;
        }

        try {
            socket = new Socket(host,port);
            System.out.println("connected");
            callback.invoke(null, null);

        } catch (IOException ex) {
            System.out.println(ex.toString());
            callback.invoke("Connection refused", null);
        }
    }

    @ReactMethod
    public void read(int timeout, Callback callback) {

        if(socket == null) {
            callback.invoke("Connection has not been setup", null);
            return;
        }

        try {

            reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));

            String line;
            String response = "";

            sleep(250);
            while(reader.ready() && (line = reader.readLine()) != null) {
                System.out.printf("m=readInput status=read, line=%s%n" , line);
                response = response.concat(line);
                response = response.concat("\r\n");
            }

            System.out.println("finished reading");
            callback.invoke(null, response);

        } catch (IOException | InterruptedException e) {
            System.out.println(e.toString());
            callback.invoke("Unable to read the data received", null);
        }
    }

    @ReactMethod
    public void write(String string, int timeout, Callback callback) {

        // timeout not used for android but needed for method consistency across applications
        if(socket == null) {
            callback.invoke("Connection has not been setup", null);
            return;
        }

        try {

            writer = new PrintWriter(socket.getOutputStream(), true);
            writer.println(string);
            writer.flush();
            callback.invoke(null, null);

        } catch (IOException ex) {
            System.out.println(ex.toString());
            callback.invoke("Unable to send the data to the receiver", null);
        }
    }
}
