if [[ $TARGET_SINGLE_SYSTEM_IMAGE == "essi" || $TARGET_SINGLE_SYSTEM_IMAGE == "essi_64" ]]; then
    echo "Exynos target device detected! Patching..."

    # Delete all QCOM/QTI blobs
    ITEMS=$(find "$WORK_DIR/product" -name "*qti*")
    for item in $ITEMS
    do
        if [ -e "$item" ]; then
            item_relative=$(echo "$item" | sed "s|$WORK_DIR/product/||")
            DELETE_FROM_WORK_DIR "product" "$item_relative"
        fi
    done

    ITEMS=$(find "$WORK_DIR/system" -name "*qti*" )
    ITEMS+=$(find "$WORK_DIR/system" -name "*qcom*")
    ITEMS+=$(find "$WORK_DIR/system" -name "*qualcomm*")
    ITEMS+=$(find "$WORK_DIR/system" -name "*qcc*")
    ITEMS+=$(find "$WORK_DIR/system" -name "*com.quicinc.cne*")
    for item in $ITEMS
    do
        if [ -e "$item" ]; then
            item_relative=$(echo "$item" | sed "s|$WORK_DIR/system/||")
            DELETE_FROM_WORK_DIR "system" "$item_relative"
        fi
    done

    if $TARGET_HAS_SYSTEM_EXT; then
        ITEMS=$(find "$WORK_DIR/system_ext" -name "*qti*")
        ITEMS+=$(find "$WORK_DIR/system_ext" -name "*qcom*")
        ITEMS+=$(find "$WORK_DIR/system_ext" -name "*qualcomm*")
        ITEMS+=$(find "$WORK_DIR/system_ext" -name "*qcc*")
        ITEMS+=$(find "$WORK_DIR/system_ext" -name "*com.quicinc.cne*")
        for item in $ITEMS
        do
            if [ -e "$item" ]; then
                item_relative=$(echo "$item" | sed "s|$WORK_DIR/system_ext/||")
                DELETE_FROM_WORK_DIR "system_ext" "$item_relative"
            fi
        done
    fi

    # Delete some extra blobs
    BLOBS_LIST="
    system/bin/dhkprov
    system/bin/diagsylincom
    system/bin/sbauth
    system/bin/sec_diag_uart_log
    system/etc/init/dhkprov.rc
    system/etc/init/diagsylincom.rc
    system/etc/init/insthk_qsee.rc
    system/etc/init/sbauth.rc
    system/framework/QPerformance.jar
    system/framework/QXPerformance.jar
    system/framework/UxPerformance.jar
    system/framework/tcmclient.jar
    system/framework/tcmiface.jar
    system/framework/telephony-ext.jar
    system/lib64/blockchain_aidl_comm_client.so
    system/lib64/payment_aidl_comm_client.so
    "
    for blob in $BLOBS_LIST
    do
        DELETE_FROM_WORK_DIR "system" "$blob"
    done

    BLOBS_LIST="
    app
    bin/MemHalTest-system
    bin/diag_callback_sample_system
    bin/diag_dci_sample_RF_ACT
    bin/diag_dci_sample_system
    bin/diag_mdlog_system
    bin/perfservice
    bin/qcrosvm
    bin/test_diag_system
    bin/usbudev
    etc/dpm
    etc/init/perfservice.rc
    etc/init/qsguard.rc
    etc/init/qspa_system.rc
    etc/init/sxrauxd_ext.rc
    etc/init/tcmd.rc
    etc/init/usbudev.rc
    etc/perf
    etc/permissions/audiosphere.xml
    etc/permissions/datachannellib.xml
    etc/permissions/dpmapi.xml
    etc/permissions/privapp-permissions-aptxals.xml
    etc/qspa
    etc/seccomp_policy
    framework/ActivityExt.jar
    framework/audiosphere.jar
    framework/datachannellib.jar
    framework/dpmapi.jar
    framework/qmapbridge.jar
    lib64
    "
    for blob in $BLOBS_LIST
    do
        DELETE_FROM_WORK_DIR "system_ext" "$blob"
    done

    BLOBS_LIST="
    bin
    etc/init
    etc/permissions/UimService.xml
    etc/selinux
    etc/vintf
    framework
    "
    for blob in $BLOBS_LIST
    do
        DELETE_FROM_WORK_DIR "product" "$blob"
    done

    BLOBS_LIST="
    etc/selinux/precompiled_sepolicy.product_sepolicy_and_mapping.sha256
    etc/ueventd.rc
    "
    for blob in $BLOBS_LIST
    do
        DELETE_FROM_WORK_DIR "odm" "$blob"
    done

    # Now add Exynos libs, sigh...
    BLOBS_LIST="
    system/app/TEEgrisTuiService/TEEgrisTuiService.apk
    system/app/TEEgrisTuiService/oat/arm64/TEEgrisTuiService.odex
    system/app/TEEgrisTuiService/oat/arm64/TEEgrisTuiService.vdex
    system/bin/audioserver
    system/bin/bootanimation
    system/bin/heatmap
    system/bin/insthk
    system/bin/remotedisplay
    system/bin/surfaceflinger
    system/etc/boot-image.bprof
    system/etc/boot-image.prof
    system/etc/classpaths/bootclasspath.pb
    system/etc/init/init.gpscommon.rc
    system/etc/init/init.network.rc
    system/etc/init/init.rilchip.slsi.rc
    system/etc/init/init.sec-heatmap.rc
    system/etc/init/insthk_teegris.rc
    system/etc/init/surfaceflinger.rc
    system/etc/permissions/com.android.nfc_extras.xml
    system/etc/public.libraries-edensdk.samsung.txt
    system/etc/sysconfig/preinstalled-packages-com.samsung.sec.android.teegris.tui_service.xml
    system/etc/ueventd.rc
    system/etc/vintf/compatibility_matrix.202404.xml
    system/etc/vintf/compatibility_matrix.5.xml
    system/etc/vintf/compatibility_matrix.6.xml
    system/etc/vintf/compatibility_matrix.7.xml
    system/etc/vintf/compatibility_matrix.8.xml
    system/etc/vintf/compatibility_matrix.device.xml
    system/etc/vintf/manifest.xml
    system/framework/com.android.nfc_extras.jar
    system/framework/displayaiqe_svc.jar
    system/framework/ssrm.jar
    system/framework/vendor.samsung_slsi.telephony.hardware.oemservice-V1-java.jar
    system/lib64/android.hardware.graphics.composer3-V1-ndk.so
    system/lib64/android.hardware.graphics.extension.composer3-V1-ndk.so
    system/lib64/hidl_tlc_blockchain_comm_client.so
    system/lib64/hidl_tlc_payment_comm_client.so
    system/lib64/libSurfaceFlingerProp.so
    system/lib64/libandroid_runtime.so
    system/lib64/libandroid_runtime_lazy.so
    system/lib64/libaudiopolicy.so
    system/lib64/libaudiopolicycomponents.so
    system/lib64/libaudiopolicyengineconfigurable.so
    system/lib64/libaudiopolicyenginedefault.so
    system/lib64/libaudiopolicymanagerdefault.so
    system/lib64/libeden_nn_on_system.so
    system/lib64/libeden_rt_stub.edensdk.samsung.so
    system/lib64/libgui.so
    system/lib64/libui.so
    system/lib64/libhdcp2.so
    system/lib64/libhdcp_client_aidl.so
    system/lib64/libhidl_comm_mpos_tui_client.so
    system/lib64/libremotedesktopservice.so
    system/lib64/libremotedisplay.so
    system/lib64/libremotedisplay_wfd.so
    system/lib64/libremotedisplayservice.so
    system/lib64/librepeater.so
    system/lib64/libsamsung_keystore_utils.so
    system/lib64/libsecuibc.so
    system/lib64/libstagefright_hdcp.so
    system/lib64/libteecl_aidl.so
    system/lib64/libtlc_blockchain_comm.so
    system/lib64/libtlc_blockchain_direct_comm.so
    system/lib64/libtlc_blockchain_keystore.so
    system/lib64/libtlc_payment_comm.so
    system/lib64/libtlc_payment_direct_comm.so
    system/lib64/libtlc_payment_spay.so
    system/lib64/libtsmux.so
    system/lib64/libtui_service_jni.so
    system/lib64/vendor.samsung.hardware.security.hdcp.wifidisplay-V2-ndk.so
    system/lib64/vendor.samsung.hardware.tlc.blockchain@1.0.so
    system/lib64/vendor.samsung.hardware.tlc.payment@1.0.so
    system/lib64/vendor.samsung_slsi.hardware.ExynosHWCServiceTW@1.0.so
    system/lib64/vendor.samsung_slsi.hardware.eden_runtime@1.0.so
    system/priv-app/SamsungDeviceHealthManagerService/SamsungDeviceHealthManagerService.apk
    system/priv-app/SamsungDeviceHealthManagerService/oat/arm64/SamsungDeviceHealthManagerService.odex
    system/priv-app/SamsungDeviceHealthManagerService/oat/arm64/SamsungDeviceHealthManagerService.vdex
    "
    for blob in $BLOBS_LIST
    do
        ADD_TO_WORK_DIR "e2sxxx" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
    done

    # Now add Exynos libs, sigh...
    BLOBS_LIST="
    system/app
    system/bin
    system/etc
    system/framework
    system/priv-app
    "
    for blob in $BLOBS_LIST
    do
        ADD_TO_WORK_DIR "e2sxxx" "system" "$blob" 0 0 644 "u:object_r:system_file:s0"
    done

    ADD_TO_WORK_DIR "e2sxxx" "system_ext" "etc/selinux" 0 0 644 "u:object_r:system_file:s0"
    ADD_TO_WORK_DIR "e2sxxx" "odm" "etc/selinux" 0 0 644 "u:object_r:system_file:s0"

    # Create TEEgrisTUIService symlink
    mkdir -p "$WORK_DIR/system/system/app/TEEgrisTuiService/lib/arm64"
    ln -sf "/system/lib64/libtui_service_jni.so" "$WORK_DIR/system/system/app/TEEgrisTuiService/lib/arm64/libtui_service_jni.so"
    SET_METADATA "system" "system/app/TEEgrisTuiService/lib" 0 0 755 "u:object_r:system_file:s0"
    SET_METADATA "system" "system/app/TEEgrisTuiService/lib/arm64" 0 0 755 "u:object_r:system_file:s0"
    SET_METADATA "system" "system/app/TEEgrisTuiService/lib/arm64/libtui_service_jni.so" 0 0 644 "u:object_r:system_file:s0"

    # Remove Qualcomm Props
    SET_PROP "system" "rild.libpath" --delete
    SET_PROP "system" "ril.subscription.types" --delete
    SET_PROP "system" "DEVICE_PROVISIONED" --delete
    SET_PROP "system" "dalvik.vm.heapsize" --delete
    SET_PROP "system" "dev.pm.dyn_samplingrate" --delete
    SET_PROP "system" "qcom.hw.aac.encoder" --delete
    SET_PROP "system" "persist.vendor.cne.feature" --delete
    SET_PROP "system" "media.stagefright.enable-player" --delete
    SET_PROP "system" "media.stagefright.enable-http" --delete
    SET_PROP "system" "media.stagefright.enable-aac" --delete
    SET_PROP "system" "media.stagefright.enable-qcp" --delete
    SET_PROP "system" "media.stagefright.enable-fma2dp" --delete
    SET_PROP "system" "media.stagefright.enable-scan" --delete
    SET_PROP "system" "media.stagefright.thumbnail.prefer_hw_codecs" --delete
    SET_PROP "system" "mmp.enable.3g2" --delete
    SET_PROP "system" "media.aac_51_output_enabled" --delete
    SET_PROP "system" "vendor.mm.enable.qcom_parser" --delete
    SET_PROP "system" "ro.bluetooth.library_name" --delete
    SET_PROP "system" "persist.vendor.btstack.aac_frm_ctl.enabled" --delete
    SET_PROP "system" "persist.rmnet.data.enable" --delete
    SET_PROP "system" "persist.data.wda.enable" --delete
    SET_PROP "system" "persist.data.df.dl_mode" --delete
    SET_PROP "system" "persist.data.df.ul_mode" --delete
    SET_PROP "system" "persist.data.df.agg.dl_pkt" --delete
    SET_PROP "system" "persist.data.df.agg.dl_size" --delete
    SET_PROP "system" "persist.data.df.mux_count" --delete
    SET_PROP "system" "persist.data.df.iwlan_mux" --delete
    SET_PROP "system" "persist.data.df.dev_name" --delete
    SET_PROP "system" "sys.qca1530" --delete
    SET_PROP "system" "persist.debug.coresight.config" --delete
    SET_PROP "system" "persist.vendor.radio.atfwd.start" --delete
    SET_PROP "system" "qemu.hw.mainkeys" --delete
    SET_PROP "system" "vendor.camera.aux.packagelist" --delete
    SET_PROP "system" "persist.vendor.camera.privapp.list" --delete
    SET_PROP "system" "debug.stagefright.ccodec" --delete
    SET_PROP "system" "ro.media.recorder-max-base-layer-fps" --delete
    SET_PROP "system" "ro.charger.enable_suspend" --delete
    SET_PROP "system" "arm64.memtag.process.system_server" --delete
    SET_PROP "system" "ro.launcher.blur.appLaunch" --delete
    SET_PROP "system" "ro.bluetooth.finder.supported" --delete
    SET_PROP "system" "ro.vendor.qti.va_aosp.support" --delete

    # Add Exynos Props
    SET_PROP "system" "persist.demo.hdmirotationlock" "false"
    SET_PROP "system" "dev.usbsetting.embedded" "on"
    SET_PROP "system" "log.tag.EDEN" "INFO"
    SET_PROP "system" "ro.debug_level" "0x494d"
    SET_PROP "system" "ro.vendor.cscsupported" "1"
    SET_PROP "system" "audio.offload.min.duration.secs" "30"
    SET_PROP "system" "bluetooth.profile.asha.central.enabled" "true"
    SET_PROP "system" "bluetooth.profile.a2dp.source.enabled" "true"
    SET_PROP "system" "bluetooth.profile.avrcp.target.enabled" "true"
    SET_PROP "system" "bluetooth.profile.gatt.enabled" "true"
    SET_PROP "system" "bluetooth.profile.hfp.ag.enabled" "true"
    SET_PROP "system" "bluetooth.profile.hid.device.enabled" "true"
    SET_PROP "system" "bluetooth.profile.hid.host.enabled" "true"
    SET_PROP "system" "bluetooth.profile.map.server.enabled" "true"
    SET_PROP "system" "bluetooth.profile.opp.enabled" "false"
    SET_PROP "system" "bluetooth.profile.pan.nap.enabled" "true"
    SET_PROP "system" "bluetooth.profile.pan.panu.enabled" "true"
    SET_PROP "system" "bluetooth.profile.pbap.server.enabled" "true"
    SET_PROP "system" "bluetooth.device.class_of_device" "90,2,12"
else
    echo "Target device is not an Exynos device. Ignoring"
fi
