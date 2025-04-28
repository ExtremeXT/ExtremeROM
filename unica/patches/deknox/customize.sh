# A56 VOLD/MDF blobs
ADD_TO_WORK_DIR "a56xnaxx" "system" "."

# Tab S10 FE android_server blobs
ADD_TO_WORK_DIR "gts10fewifixx" "system" "."

# KnoxGuard
DELETE_FROM_WORK_DIR "system" "system/priv-app/KnoxGuard"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.kgclient.xml"

# DualDAR
DELETE_FROM_WORK_DIR "system" "system/bin/dualdard"
DELETE_FROM_WORK_DIR "system" "system/etc/init/dualdard.rc"
DELETE_FROM_WORK_DIR "system" "system/lib64/libdualdar.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/aidl_comm_ddar_client.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/vendor.samsung.hardware.tlc.ddar-V1-ndk.so"

# Blockchain
DELETE_FROM_WORK_DIR "system" "system/app/BlockchainBasicKit"
DELETE_FROM_WORK_DIR "system" "system/framework/service-samsung-blockchain.jar"
DELETE_FROM_WORK_DIR "system" "system/etc/sysconfig/preinstalled-packages-com.samsung.android.coldwalletservice.xml"
DELETE_FROM_WORK_DIR "system" "system/lib64/hidl_tlc_blockchain_comm_client.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/libtlc_blockchain_comm.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/libtlc_blockchain_keystore.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/libtlc_blockchain_direct_comm.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/vendor.samsung.hardware.tlc.blockchain@1.0.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/vendor.samsung.hardware.tlc.blockchain-V1-ndk.so"
SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_FRAMEWORK_SUPPORT_BLOCKCHAIN_SERVICE" --delete

# Payment
DELETE_FROM_WORK_DIR "system" "system/lib64/hidl_tlc_payment_comm_client.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/libtlc_payment_direct_comm.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/libtlc_payment_spay.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/libtlc_payment_comm.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/vendor.samsung.hardware.tlc.payment@1.0.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/vendor.samsung.hardware.tlc.payment-V1-ndk.so"

# MPOS
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.knox.mpos.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/com.samsung.android.nfc.mpos.xml"
DELETE_FROM_WORK_DIR "system" "system/framework/com.samsung.android.nfc.mpos.jar"
DELETE_FROM_WORK_DIR "system" "system/lib64/libhidl_comm_mpos_tui_client.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/vendor.samsung.hardware.mpos-V1-ndk.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/vendor.samsung.hardware.tlc.mpos_tui@1.0.so"
DELETE_FROM_WORK_DIR "system" "system/priv-app/KnoxMposAgent"

# eSE COS
DELETE_FROM_WORK_DIR "system" "system/bin/sem_daemon"
DELETE_FROM_WORK_DIR "system" "system/etc/init/sem_early.rc"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.sem.factoryapp.xml"
DELETE_FROM_WORK_DIR "system" "system/lib64/libsec_sem.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/libsec_semAidl.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/libsec_semRil.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/libsec_semTlc.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/libspictrl.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/vendor.samsung.hardware.security.sem-V1-ndk.so"
DELETE_FROM_WORK_DIR "system" "system/priv-app/SEMFactoryApp"

# Weaver
DELETE_FROM_WORK_DIR "system" "system/lib64/libhermes_cred.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/android.hardware.weaver-V2-ndk.so"

# HDM
DELETE_FROM_WORK_DIR "system" "system/priv-app/HdmApk"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.hdmapp.xml"

# Knox ZeroTrust
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.knox.zt.framework.xml"
DELETE_FROM_WORK_DIR "system" "system/priv-app/KnoxZtFramework"

# Other Knox APKs
DELETE_FROM_WORK_DIR "system" "system/priv-app/KPECore"
DELETE_FROM_WORK_DIR "system" "system/priv-app/KnoxCore"
DELETE_FROM_WORK_DIR "system" "system/priv-app/KnoxERAgent"
DELETE_FROM_WORK_DIR "system" "system/priv-app/KnoxFrameBufferProvider"
DELETE_FROM_WORK_DIR "system" "system/priv-app/KnoxNetworkFilter"
DELETE_FROM_WORK_DIR "system" "system/priv-app/KnoxNeuralNetworkRuntime"
DELETE_FROM_WORK_DIR "system" "system/priv-app/KnoxPushManager"
DELETE_FROM_WORK_DIR "system" "system/priv-app/KnoxSandbox"
DELETE_FROM_WORK_DIR "system" "system/priv-app/knoxanalyticsagent"
DELETE_FROM_WORK_DIR "system" "system/priv-app/knoxvpnproxyhandler"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.knox.vpn.proxyhandler.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.knox.analytics.uploader.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.knox.app.networkfilter.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.knox.er.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.knox.kfbp.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.knox.knnr.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.knox.kpecore.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.knox.pushmanager.xml"
DELETE_FROM_WORK_DIR "system" "system/etc/permissions/privapp-permissions-com.samsung.android.knox.sandbox.xml"
