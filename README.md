# react-native-core-motion

## Getting started

`$ npm install react-native-core-motion --save`

### Mostly automatic installation

`$ react-native link react-native-core-motion`

## Usage
```javascript
import CoreMotionModule from 'react-native-core-motion';

    CoreMotionModule.isAvailable((available) => {
      if (available) {
        CoreMotionModule.recordMotions()
        CoreMotionModule.loadRecordedData()
          .then((resolve) => this.setState({ status: "OK", message: "Count: " + resolve.length, sample: JSON.stringify(resolve[0]) }))
          .catch((error) => this.setState({ status: error.message }));
      }
    })
```

## Add iOS info.plist

```
    <key>NSMotionUsageDescription</key>
    <string>Core Motion required description</string>
```