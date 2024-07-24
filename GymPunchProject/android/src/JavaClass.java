package org.qtproject.example;

import android.Manifest;
import com.google.gson.Gson;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import java.util.Map;
import java.util.List;
import java.util.HashSet;
import java.util.Set;
import java.util.ArrayList;
import android.app.Activity;
import android.content.Context;
import android.bluetooth.BluetoothDevice;
import com.onecoder.fitblekit.API.Boxing.FBKApiBoxing;
import com.onecoder.fitblekit.API.Boxing.FBKApiBoxingCallBack;
import com.onecoder.fitblekit.API.ScanDevices.FBKApiScan;
import com.onecoder.fitblekit.API.Base.FBKApiBsaeMethod;
import com.onecoder.fitblekit.API.ScanDevices.FBKApiScanCallBack;
import com.onecoder.fitblekit.Ble.FBKBleDevice.FBKBleDevice;
import com.onecoder.fitblekit.Ble.FBKBleDevice.FBKBleDeviceStatus;
import com.onecoder.fitblekit.API.Base.FBKBleBaseInfo;
import com.onecoder.fitblekit.Protocol.Boxing.BoxingAxisType;
import com.onecoder.fitblekit.Protocol.Boxing.FBKBoxingAxis;
import com.onecoder.fitblekit.Protocol.Boxing.FBKBoxingSet;
import com.onecoder.fitblekit.Tools.FBKSpliceBle;

public class JavaClass {

    //private static FBKApiScan bleScanner = new FBKApiScan(); // Initialize here
    //private static FBKApiBoxing bleDeviceApi; // Initialize here
    private static List<FBKApiBoxing> connectedDevices = new ArrayList<>(); // List to keep track of connected devices
    //private static Set<String> seenDevices = new HashSet<>();

    // Native method declaration
    private static native void onRealTimeBoxingData(String macAdd, String jsonData);;

    public JavaClass() {
        System.out.println("JavaClass Class CALLED");
        //bleScanner = new FBKApiScan();
    }

    /*public static String getJavaMessage() {
        System.out.println("Output from java: Hello, Yemi Omo Boda Fagbohun!!! ");
        return "Hello, Yemi Omo Boda Fagbohun!!!";
    }*/
    private static void sendRealTimeBoxingData(String macAdd, Object realTimeBoxingData) {
        // Convert the real-time boxing data to JSON
        String jsonData = convertToJson(realTimeBoxingData);

        // Call native method to pass the data to C++
        onRealTimeBoxingData(macAdd, jsonData);
    }

    private static String convertToJson(Object realTimeBoxingData) {
        // Implement this method to convert your real-time boxing data to a JSON string
        // You can use a library like Gson or Jackson for this
        Gson gson = new Gson();
        return gson.toJson(realTimeBoxingData);
    }

    private static void connectToDevice(String macAdd, Activity activity) {
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                System.out.println("connectToDevice Method CALLED with: " + macAdd);
                FBKApiBoxing bleDeviceApi = new FBKApiBoxing(activity, new FBKApiBoxingCallBack() {
                    @Override
                    public void bleConnectError(String error, FBKApiBsaeMethod apiBsaeMethod) {
                        // Handle connection error here
                        System.out.println("Connection Error: " + error);
                    }

                    @Override
                    public void bleConnectStatus(FBKBleDeviceStatus connectStatus, FBKApiBsaeMethod apiBsaeMethod) {
                        // Handle connection status here
                        System.out.println("Connection Status: " + connectStatus);

                    }
                    @Override
                    public void realtimeAxis(List<FBKBoxingAxis> axisData, int dataType, int modeType, FBKApiBoxing apiBoxing) {
                        // Handle real-time boxing axis data here
                        System.out.println("Real-time Axis Data: " + axisData);
                    }
                    @Override
                    public void boxingAxisSwitchResult(boolean isSuccess, FBKApiBoxing apiBoxing) {
                        // Handle boxing axis switch result here
                        System.out.println("Boxing Axis Switch Result: " + isSuccess);
                    }
                    @Override
                    public void boxingRecord(Object recordData, FBKApiBoxing apiBoxing) {
                        // Handle boxing record data here
                        System.out.println("Boxing Record Data: " + recordData);
                    }
                    @Override
                     public void realTimeBoxing(Object data, FBKApiBoxing apiBoxing) {
                        // Handle real-time boxing data here
                        //System.out.println("Real-time Boxing Data: " + data);
                        sendRealTimeBoxingData(macAdd, data);
                    }
                    @Override
                    public void bleConnectStatusLog(String infoString, FBKApiBsaeMethod apiBsaeMethod) {

                    }

                    @Override
                    public void batteryPower(final int power, FBKApiBsaeMethod apiBsaeMethod) {

                        System.out.println("Read Battery Power"+"   ("+String.valueOf(power)+"%"+")");

                    }

                    @Override
                    public void protocolVersion(String version, FBKApiBsaeMethod apiBsaeMethod) {
                    }

                    @Override
                    public void firmwareVersion(String version, FBKApiBsaeMethod apiBsaeMethod) {

                    }

                    @Override
                    public void hardwareVersion(String version, FBKApiBsaeMethod apiBsaeMethod) {

                    }

                    @Override
                    public void softwareVersion(String version, FBKApiBsaeMethod apiBsaeMethod) {

                    }

                    @Override
                    public void privateVersion(Map<String, String> versionMap, FBKApiBsaeMethod apiBsaeMethod) {

                    }

                    @Override
                    public void privateMacAddress(Map<String, String> macMap, FBKApiBsaeMethod apiBsaeMethod) {

                    }


                    @Override
                    public void bleConnectInfo(String infoString, FBKApiBsaeMethod apiBsaeMethod) {

                    }

                    @Override
                    public void deviceSystemData(byte[] systemData, FBKApiBsaeMethod apiBsaeMethod) {

                    }

                    @Override
                    public void deviceModelString(String modelString, FBKApiBsaeMethod apiBsaeMethod) {

                    }

                    @Override
                    public void deviceSerialNumber(String serialNumber, FBKApiBsaeMethod apiBsaeMethod) {

                    }

                    @Override
                    public void deviceManufacturerName(String manufacturerName, FBKApiBsaeMethod apiBsaeMethod) {

                    }

                    @Override
                    public void deviceBaseInfo(FBKBleBaseInfo baseInfo, FBKApiBsaeMethod apiBsaeMethod) {

                       System.out.println("macAddress: "+baseInfo.getDeviceMac());
                    }
                });

                bleDeviceApi.registerBleListenerReceiver();
                bleDeviceApi.connectBluetooth(macAdd);
                connectedDevices.add(bleDeviceApi);
            }
        });

    }
    public static void disconnectDevice() {
        for (FBKApiBoxing bleDeviceApi : connectedDevices) {
            if (bleDeviceApi != null) {
                bleDeviceApi.disconnectBle();
                bleDeviceApi.unregisterBleListenerReceiver();
            }
        }
        connectedDevices.clear();
        System.out.println("All Devices Disconnected.");

    }

}
