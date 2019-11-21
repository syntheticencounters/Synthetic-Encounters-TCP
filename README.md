# se-tcp

## Getting started

`$ npm install se-tcp --save`

### Mostly automatic installation

`$ react-native link se-tcp`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `se-tcp` and add `SETcp.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libSETcp.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainApplication.java`
  - Add `import com.reactlibrary.SETcpPackage;` to the imports at the top of the file
  - Add `new SETcpPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':se-tcp'
  	project(':se-tcp').projectDir = new File(rootProject.projectDir, 	'../node_modules/se-tcp/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':se-tcp')
  	```

#### Windows
[Read it! :D](https://github.com/ReactWindows/react-native)

1. In Visual Studio add the `SETcp.sln` in `node_modules/se-tcp/windows/SETcp.sln` folder to their solution, reference from their app.
2. Open up your `MainPage.cs` app
  - Add `using Tcp.SETcp;` to the usings at the top of the file
  - Add `new SETcpPackage()` to the `List<IReactPackage>` returned by the `Packages` method


## Usage
```javascript
import SETcp from 'se-tcp';

// TODO: What to do with the module?
SETcp;
```
  