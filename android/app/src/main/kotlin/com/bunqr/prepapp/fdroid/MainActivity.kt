package com.bunqr.prepapp.fdroid  // <-- ajuste para o seu applicationId

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationManager
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "app.location"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getCurrentLocation" -> {
                        val lm = getSystemService(Context.LOCATION_SERVICE) as LocationManager

                        val fine = ActivityCompat.checkSelfPermission(
                            this, Manifest.permission.ACCESS_FINE_LOCATION
                        ) == PackageManager.PERMISSION_GRANTED
                        val coarse = ActivityCompat.checkSelfPermission(
                            this, Manifest.permission.ACCESS_COARSE_LOCATION
                        ) == PackageManager.PERMISSION_GRANTED

                        if (!fine && !coarse) {
                            result.error("NO_PERMISSION", "Location permission not granted", null)
                            return@setMethodCallHandler
                        }

                        // Tenta obter o melhor "lastKnown" entre GPS/NETWORK/PASSIVE
                        val providers = listOf(
                            LocationManager.GPS_PROVIDER,
                            LocationManager.NETWORK_PROVIDER,
                            LocationManager.PASSIVE_PROVIDER
                        )

                        var best: Location? = null
                        for (p in providers) {
                            try {
                                val l = lm.getLastKnownLocation(p)
                                if (l != null && (best == null || l.time > best!!.time)) {
                                    best = l
                                }
                            } catch (_: SecurityException) {
                            } catch (_: IllegalArgumentException) {
                            }
                        }

                        if (best != null) {
                            result.success(
                                hashMapOf(
                                    "latitude" to best.latitude,
                                    "longitude" to best.longitude,
                                    "accuracy" to (best.accuracy.toDouble())
                                )
                            )
                        } else {
                            // Sem lastKnown; você pode evoluir para solicitar uma atualização única com requestLocationUpdates() + timeout.
                            result.error("NO_FIX", "No last known location", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
