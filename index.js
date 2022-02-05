// main index.js

import { NativeModules } from 'react-native';

const { CoreMotionModule } = NativeModules;

export default {
    isAvailable: (callback) => CoreMotionModule.isAvailable(callback),
    recordMotions: () => CoreMotionModule.recordMotions(),
    loadRecordedData: () => new Promise(
        (resolve, reject) => {
            CoreMotionModule.loadRecordedData().then(resolve).catch(reject)
        }
    )
};
