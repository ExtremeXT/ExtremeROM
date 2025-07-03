BLOBS_LIST="
system/lib64/libpic_best.arcsoft.so
system/lib64/libhybrid_high_dynamic_range.arcsoft.so
system/lib64/libface_recognition.arcsoft.so
"
for blob in $BLOBS_LIST
do
    DELETE_FROM_WORK_DIR "system" "$blob"
done

echo "Add stock camera libs"
BLOBS_LIST="
system/lib64/libMultiFrameProcessing30.camera.samsung.so
system/lib64/libMultiFrameProcessing30.snapwrapper.camera.samsung.so
system/lib64/libMultiFrameProcessing30Tuning.camera.samsung.so
system/lib64/libSwIsp_core.camera.samsung.so
system/lib64/libSwIsp_wrapper_v1.camera.samsung.so
system/lib64/libVideoClassifier.camera.samsung.so
system/lib64/libDocShadowRemoval.arcsoft.so
system/lib64/libHpr_RecFace_dl_v1.0.camera.samsung.so
system/lib64/libImageSegmenter_v1.camera.samsung.so
system/lib64/libObjectDetector_v1.camera.samsung.so
system/lib64/libSceneDetector_v1.camera.samsung.so
system/lib64/libDualCamBokehCapture.camera.samsung.so
system/lib64/libPortraitDistortionCorrection.arcsoft.so
system/lib64/libarcsoft_dualcam_portraitlighting.so
system/lib64/vendor.samsung_slsi.hardware.eden_runtime@1.0.so
system/lib64/libhigh_dynamic_range.arcsoft.so
system/lib64/liblow_light_hdr.arcsoft.so
system/lib64/libsnap_aidl.snap.samsung.so
system/lib64/libsuperresolution_raw.arcsoft.so
system/lib64/libsuperresolutionraw_wrapper_v2.camera.samsung.so
system/lib64/vendor.samsung.hardware.snap-V3-ndk.so
system/lib64/libdualcam_portraitlighting_gallery_360.so
system/lib64/libHREnhancementAPI.camera.samsung.so
system/lib64/libdualcam_refocus_image.so
system/lib64/libarcsoft_superresolution_bokeh.so
"
if [[ "$TARGET_CODENAME" == "r0s" || "$TARGET_CODENAME" == "g0s" ]]; then
    BLOBS_LIST+="
    system/lib64/libAEBHDR_wrapper.camera.samsung.so
    system/lib64/libae_bracket_hdr.arcsoft.so
    "
elif [[ "$TARGET_CODENAME" == "b0s" ]]; then
    BLOBS_LIST+="
    system/lib64/libuwsuperresolution_wrapper_v1.camera.samsung.so
    system/lib64/libuwsuperresolution.arcsoft.so
    system/lib64/libhigh_res.arcsoft.so
    "
fi
for blob in $BLOBS_LIST
do
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
done

# Fix portrait mode
sed -i "s/ro.product.name/ro.unica.camera/g" "$WORK_DIR/system/system/lib64/libDualCamBokehCapture.camera.samsung.so"
