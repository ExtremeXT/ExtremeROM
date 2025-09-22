LOG_STEP_IN "- Replacing camera blobs"
BLOBS_LIST="
system/lib64/libenn_wrapper_system.so
system/lib64/libpic_best.arcsoft.so
system/lib64/libarcsoft_dualcam_portraitlighting.so
system/lib64/libdualcam_refocus_gallery_54.so
system/lib64/libdualcam_refocus_gallery_50.so
system/lib64/libhybrid_high_dynamic_range.arcsoft.so
system/lib64/libae_bracket_hdr.arcsoft.so
system/lib64/libface_recognition.arcsoft.so
system/lib64/libDualCamBokehCapture.camera.samsung.so
"
for blob in $BLOBS_LIST
do
    DELETE_FROM_WORK_DIR "system" "$blob" &
done

# shellcheck disable=SC2046
wait $(jobs -p) || exit 1

BLOBS_LIST="
system/lib64/android.frameworks.cameraservice.common@2.0.so
system/lib64/android.frameworks.cameraservice.device@2.0.so
system/lib64/android.frameworks.cameraservice.device@2.1.so
system/lib64/android.frameworks.cameraservice.service@2.0.so
system/lib64/android.frameworks.cameraservice.service@2.1.so
system/lib64/android.frameworks.cameraservice.service@2.2.so
system/lib64/android.hardware.camera.common@1.0.so
system/lib64/android.hardware.camera.device@1.0.so
system/lib64/android.hardware.camera.device@3.2.so
system/lib64/android.hardware.camera.device@3.3.so
system/lib64/android.hardware.camera.device@3.4.so
system/lib64/android.hardware.camera.device@3.5.so
system/lib64/android.hardware.camera.device@3.6.so
system/lib64/android.hardware.camera.device@3.7.so
system/lib64/android.hardware.camera.metadata@3.2.so
system/lib64/android.hardware.camera.metadata@3.3.so
system/lib64/android.hardware.camera.metadata@3.4.so
system/lib64/android.hardware.camera.metadata@3.5.so
system/lib64/android.hardware.camera.metadata@3.6.so
system/lib64/android.hardware.camera.provider@2.4.so
system/lib64/android.hardware.camera.provider@2.5.so
system/lib64/android.hardware.camera.provider@2.6.so
system/lib64/android.hardware.camera.provider@2.7.so
system/lib64/camera-service-worker-aidl-V2-cpp.so
system/lib64/lib_android_FrameCapture.so
system/lib64/libagifencoder.quram.so
system/lib64/libBeauty_v4.camera.samsung.so
system/lib64/libbeautyshot.arcsoft.so
system/lib64/libcamera_client.so
system/lib64/libcamera_metadata.so
system/lib64/libcamera2ndk.so
system/lib64/libcameraservice.so
system/lib64/libcodec2_client.so
system/lib64/libcodec2_hidl_client@1.0.so
system/lib64/libcodec2_hidl_client@1.1.so
system/lib64/libcodec2_hidl_client@1.2.so
system/lib64/libcodec2_vndk.so
system/lib64/libcodec2.so
system/lib64/libcodecdatautils.so
system/lib64/libcodecsolutionhelper.so
system/lib64/libcore2nativeutil.camera.samsung.so
system/lib64/libdng_sdk.so
system/lib64/libdynamic_depth.so
system/lib64/libEventDetector.camera.samsung.so
system/lib64/libexifa.camera.samsung.so
system/lib64/libFace_Landmark_API.camera.samsung.so
system/lib64/libFace_Landmark_Engine.camera.samsung.so
system/lib64/libface_landmark.arcsoft.so
system/lib64/libFacePreProcessing_jni.camera.samsung.so
system/lib64/libFacePreProcessing.camera.samsung.so
system/lib64/libFood.camera.samsung.so
system/lib64/libFoodDetector.camera.samsung.so
system/lib64/libheif.so
system/lib64/libheifcapture_jni.media.samsung.so
system/lib64/libheifcapture.so
system/lib64/libheifcodec_jni.so
system/lib64/libheifregiondec_jni.so
system/lib64/libhigh_dynamic_range.arcsoft.so
system/lib64/libHpr_RecFace_dl_v1.0.camera.samsung.so
system/lib64/libHpr_RecGAE_cvFeature_v1.0.camera.samsung.so
system/lib64/libHpr_TaskFaceClustering_hierarchical_v1.0.camera.samsung.so
system/lib64/libHprFace_GAE_api.camera.samsung.so
system/lib64/libHprFace_GAE_jni.camera.samsung.so
system/lib64/libhumantracking_util.camera.samsung.so
system/lib64/libimagecodec.quram.so
system/lib64/libImageScreener.camera.samsung.so
system/lib64/libInteractiveSegmentation.camera.samsung.so
system/lib64/libjpeg.so
system/lib64/libjpega.camera.samsung.so
system/lib64/libjpegsq.media.samsung.so
system/lib64/libMattingCore.camera.samsung.so
system/lib64/libmedia_codeclist.so
system/lib64/libmedia_omx_client.so
system/lib64/libmedia_omx.so
system/lib64/libmedia.so
system/lib64/libmediacapture_jni.so
system/lib64/libmediacapture.so
system/lib64/libMultiFrameProcessing10.camera.samsung.so
system/lib64/libMyFilterPlugin.camera.samsung.so
system/lib64/libObjectAndSceneClassification_2.5_OD.camera.samsung.so
system/lib64/libOpenCv.camera.samsung.so
system/lib64/libPortraitSolution.camera.samsung.so
system/lib64/libQmageDecoder.so
system/lib64/libQREngine_common.camera.samsung.so
system/lib64/libsamsung_videoengine_9_0.so
system/lib64/libsaiv_HprFace_api.camera.samsung.so
system/lib64/libsaiv_HprFace_cmh_support_jni.camera.samsung.so
system/lib64/libseccameracore2.so
system/lib64/libsecimaging_pdk.camera.samsung.so
system/lib64/libsecimaging.camera.samsung.so
system/lib64/libsecjpeginterface.camera.samsung.so
system/lib64/libsecjpegquram.so
system/lib64/libSegmentationCore.camera.samsung.so
system/lib64/libsemimagecrop_jni.media.samsung.so
system/lib64/libsemimagecrop.so
system/lib64/libsfplugin_ccodec_utils.so
system/lib64/libsfplugin_ccodec.so
system/lib64/libsmart_cropping.camera.samsung.so
system/lib64/libsrib_CNNInterface.camera.samsung.so
system/lib64/libsrib_humanaware_engine.camera.samsung.so
system/lib64/libstagefright_amrnb_common.so
system/lib64/libstagefright_bufferpool@2.0.1.so
system/lib64/libstagefright_bufferqueue_helper.so
system/lib64/libstagefright_codecbase.so
system/lib64/libstagefright_flacdec.so
system/lib64/libstagefright_foundation.so
system/lib64/libstagefright_framecapture_utils.so
system/lib64/libstagefright_http_support.so
system/lib64/libstagefright_httplive_sec.so
system/lib64/libstagefright_omx_utils.so
system/lib64/libstagefright_omx.so
system/lib64/libstagefright_xmlparser.so
system/lib64/libstagefright.so
system/lib64/libsurfaceutil.camera.samsung.so
system/lib64/libtensorflowlite_inference_api.camera.samsung.so
system/lib64/libtensorflowLite.camera.samsung.so
system/lib64/libvpx.so
system/lib64/libyuv.so
system/lib64/vendor.samsung.hardware.camera.device@5.0.so
system/lib64/vendor.samsung.hardware.camera.provider@4.0.so
system/lib64/vintf-codecsolution-V2-cpp.so
"
for blob in $BLOBS_LIST
do
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0" &
done

if [[ "$TARGET_CODENAME" == "c1s" || "$TARGET_CODENAME" == "c2s" ]]; then
    BLOBS_LIST="
    system/lib64/libofi_seva.so
    system/lib64/libofi_klm.so
    system/lib64/libofi_plugin.so
    system/lib64/libofi_rt_framework_user.so
    system/lib64/libofi_service_interface.so
    system/lib64/libofi_gc.so
    system/lib64/vendor.samsung_slsi.hardware.ofi@2.0.so
    system/lib64/vendor.samsung_slsi.hardware.ofi@2.1.so
    "
    for blob in $BLOBS_LIST
    do
        ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0" &
    done
fi

# shellcheck disable=SC2046
wait $(jobs -p) || exit 1

LOG_STEP_OUT

LOG_STEP_IN "- Removing HDR10+ check"
ADD_TO_WORK_DIR "pa3qxxx" "system" "system/lib64/libstagefright.so" 0 0 644 "u:object_r:system_lib_file:s0"
HEX_PATCH "$WORK_DIR/system/system/lib64/libstagefright.so" "010140f9cf390594a0500034" "010140f91f2003d51f2003d5"
LOG_STEP_OUT

LOG_STEP_IN "- Adding prebuilt libs from other devices"
BLOBS_LIST="
system/lib64/libc++_shared.so
"
for blob in $BLOBS_LIST
do
    ADD_TO_WORK_DIR "e2sxxx" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
done

BLOBS_LIST="
system/lib64/libeden_wrapper_system.so
system/lib64/libhigh_dynamic_range.arcsoft.so
system/lib64/liblow_light_hdr.arcsoft.so
system/lib64/libhigh_res.arcsoft.so
system/lib64/libsnap_aidl.snap.samsung.so
system/lib64/libsuperresolution.arcsoft.so
system/lib64/libsuperresolution_raw.arcsoft.so
system/lib64/libsuperresolution_wrapper_v2.camera.samsung.so
system/lib64/libsuperresolutionraw_wrapper_v2.camera.samsung.so
"
for blob in $BLOBS_LIST
do
    ADD_TO_WORK_DIR "p3sxxx" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0" &
done

# shellcheck disable=SC2046
wait $(jobs -p) || exit 1

LOG_STEP_OUT

#LOG_STEP_IN "- Adding S21 (p3sxxx) SWISP models"
#DELETE_FROM_WORK_DIR "vendor" "saiv/swisp_1.0"
#ADD_TO_WORK_DIR "p3sxxx" "vendor" "saiv/swisp_1.0"

BLOBS_LIST="
system/lib64/libSwIsp_core.camera.samsung.so
system/lib64/libSwIsp_wrapper_v1.camera.samsung.so
"
for blob in $BLOBS_LIST
do
    ADD_TO_WORK_DIR "p3sxxx" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
done
LOG_STEP_OUT

LOG_STEP_IN "- Adding S21 (p3sxxx) SingleTake models"
DELETE_FROM_WORK_DIR "vendor" "etc/singletake"
ADD_TO_WORK_DIR "p3sxxx" "vendor" "etc/singletake"

BLOBS_LIST="
system/priv-app/SingleTakeService/SingleTakeService.apk
system/cameradata/singletake/service-feature.xml
"
for blob in $BLOBS_LIST
do
    ADD_TO_WORK_DIR "p3sxxx" "system" "$blob" 0 0 644 "u:object_r:system_file:s0" &
done

# shellcheck disable=SC2046
wait $(jobs -p) || exit 1

LOG_STEP_OUT
