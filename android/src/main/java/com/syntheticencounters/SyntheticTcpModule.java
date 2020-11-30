package com.syntheticencounters;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Promise;

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
    public void connect(String host, int port, int timeout, final Promise promise) {

        // timeout not used for android but needed for method consistency across platforms
        if(host == null) {
            promise.reject("500", "Missing required host and/or port");
            return;
        }

        try {
            socket = new Socket(host,port);
            System.out.println("connected");
            promise.resolve("Connected to host");

        } catch (IOException ex) {
            System.out.println(ex.toString());
            promise.reject("500", "Connection refused");
        }
    }

    @ReactMethod
    public void read(int timeout, final Promise promise) {

        if(socket == null) {
            promise.reject("500", "Connection has not been setup");
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
            promise.resolve(response);

        } catch (IOException | InterruptedException e) {
            System.out.println(e.toString());
            promise.reject("500", "Unable to read the data received");
        }
    }

    @ReactMethod
    public void write(String string, int timeout, final Promise promise) {

        // timeout not used for android but needed for method consistency across applications
        if(socket == null) {
            promise.reject("500","Connection has not been setup");
            return;
        }

        try {

            writer = new PrintWriter(socket.getOutputStream(), true);
            writer.println(string);
            writer.flush();
            promise.resolve("Data written");

        } catch (IOException ex) {
            System.out.println(ex.toString());
            promise.reject("500", "Unable to communicate with the Comm Link");
        }
    }
}
