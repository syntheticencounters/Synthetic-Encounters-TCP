# se-tcp

## Getting started

`$ npm install se-tcp --save`

### Mostly automatic installation

`$ react-native link se-tcp`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `se-tcp` and add `SyntheticTcp.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libSyntheticTcp.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainApplication.java`
  - Add `import com.syntheticencounters.SyntheticTcpPackage;` to the imports at the top of the file
  - Add `new SyntheticTcpPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':se-tcp'
  	project(':se-tcp').projectDir = new File(rootProject.projectDir, 	'../node_modules/se-tcp/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':se-tcp')
  	```


## Usage
```javascript
import SyntheticTcp from 'se-tcp';

// TODO: What to do with the module?
SyntheticTcp;
```
