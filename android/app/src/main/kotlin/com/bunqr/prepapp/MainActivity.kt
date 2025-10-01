package com.bunqr.prepapp

import android.annotation.SuppressLint
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.GoogleApiAvailability
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority
import com.google.android.gms.tasks.CancellationTokenSource

class MainActivity : FlutterActivity() {
    private val CHANNEL = "app.location"

    @SuppressLint("MissingPermission") // A permissão já é solicitada no Dart antes de chamar o canal
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getCurrentLocation" -> {
                        // 1) Verifica Play Services
                        val playServicesStatus =
                            GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(this)
                        if (playServicesStatus != ConnectionResult.SUCCESS) {
                            result.error(
                                "PLAY_SERVICES_UNAVAILABLE",
                                "Google Play Services indisponível (code=$playServicesStatus).",
                                null
                            )
                            return@setMethodCallHandler
                        }

                        val client = LocationServices.getFusedLocationProviderClient(this)

                        // 2) Tenta rápido: lastLocation
                        client.lastLocation
                            .addOnSuccessListener { last ->
                                if (last != null) {
                                    result.success(
                                        mapOf(
                                            "latitude" to last.latitude,
                                            "longitude" to last.longitude,
                                            "accuracy" to last.accuracy.toDouble()
                                        )
                                    )
                                } else {
                                    // 3) Fallback: getCurrentLocation com alta precisão
                                    val token = CancellationTokenSource()
                                    client.getCurrentLocation(
                                        Priority.PRIORITY_HIGH_ACCURACY,
                                        token.token
                                    )
                                        .addOnSuccessListener { loc ->
                                            token.cancel()
                                            if (loc != null) {
                                                result.success(
                                                    mapOf(
                                                        "latitude" to loc.latitude,
                                                        "longitude" to loc.longitude,
                                                        "accuracy" to loc.accuracy.toDouble()
                                                    )
                                                )
                                            } else {
                                                result.success(null) // Sem posição disponível
                                            }
                                        }
                                        .addOnFailureListener { e ->
                                            token.cancel()
                                            result.error("LOC_FAIL", e.message, null)
                                        }
                                }
                            }
                            .addOnFailureListener { e ->
                                // Falhou lastLocation → tenta currentLocation
                                val token = CancellationTokenSource()
                                client.getCurrentLocation(
                                    Priority.PRIORITY_HIGH_ACCURACY,
                                    token.token
                                )
                                    .addOnSuccessListener { loc ->
                                        token.cancel()
                                        if (loc != null) {
                                            result.success(
                                                mapOf(
                                                    "latitude" to loc.latitude,
                                                    "longitude" to loc.longitude,
                                                    "accuracy" to loc.accuracy.toDouble()
                                                )
                                            )
                                        } else {
                                            result.success(null)
                                        }
                                    }
                                    .addOnFailureListener { e2 ->
                                        token.cancel()
                                        result.error("LOC_FAIL", e2.message ?: e.message, null)
                                    }
                            }
                    }

                    else -> result.notImplemented()
                }
            }
    }
}
