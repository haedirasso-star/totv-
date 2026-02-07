package com.totv.plus

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val SECURITY_CHANNEL = "com.totv.plus/security"
    private val SCREEN_CHANNEL = "com.totv.plus/screen"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Enable FLAG_SECURE by default to prevent screenshots and screen recording
        window.setFlags(
            WindowManager.LayoutParams.FLAG_SECURE,
            WindowManager.LayoutParams.FLAG_SECURE
        )
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Security Channel (FLAG_SECURE)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SECURITY_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setSecureFlag" -> {
                        val enable = call.argument<Boolean>("enable") ?: true
                        setSecureFlag(enable)
                        result.success(null)
                    }
                    "checkRootStatus" -> {
                        val isRooted = checkIfDeviceIsRooted()
                        result.success(isRooted)
                    }
                    else -> result.notImplemented()
                }
            }
        
        // Screen Channel (Keep Awake)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SCREEN_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "keepScreenOn" -> {
                        val enable = call.argument<Boolean>("enable") ?: true
                        keepScreenOn(enable)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    /**
     * Enable or disable FLAG_SECURE to prevent screenshots and screen recording
     */
    private fun setSecureFlag(enable: Boolean) {
        if (enable) {
            window.setFlags(
                WindowManager.LayoutParams.FLAG_SECURE,
                WindowManager.LayoutParams.FLAG_SECURE
            )
        } else {
            window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
        }
    }

    /**
     * Keep screen on during video playback
     */
    private fun keepScreenOn(enable: Boolean) {
        if (enable) {
            window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        } else {
            window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        }
    }

    /**
     * Check if device is rooted (basic detection)
     */
    private fun checkIfDeviceIsRooted(): Boolean {
        val paths = arrayOf(
            "/system/app/Superuser.apk",
            "/sbin/su",
            "/system/bin/su",
            "/system/xbin/su",
            "/data/local/xbin/su",
            "/data/local/bin/su",
            "/system/sd/xbin/su",
            "/system/bin/failsafe/su",
            "/data/local/su",
            "/su/bin/su"
        )
        
        for (path in paths) {
            if (java.io.File(path).exists()) {
                return true
            }
        }
        
        return false
    }
}
