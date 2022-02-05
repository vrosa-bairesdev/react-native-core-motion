// CoreMotionModule.java

package com.empatho;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

public class CoreMotionModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    public CoreMotionModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "CoreMotion";
    }

    @ReactMethod
    public void isAvailable(Callback callback){
        callback.invoke(false);
    }
}
