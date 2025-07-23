LOG_STEP_IN "- Replacing camare blobs"
BLOBS_LIST="
system/lib64/libface_recognition.arcsoft.so
system/lib64/libpic_best.arcsoft.so
system/lib64/libfrtracking_engine.arcsoft.so
system/lib64/libFaceRecognition.arcsoft.so
system/lib64/lib_pet_detection.arcsoft.so
system/lib64/libae_bracket_hdr.arcsoft.so
system/lib64/libdigital_tele_scope.arcsoft.so
system/lib64/libdigital_tele_scope_rawsr.arcsoft.so
system/lib64/libhybrid_high_dynamic_range.arcsoft.so
system/lib64/libenn_wrapper_system.so
"

for blob in $BLOBS_LIST
do
    DELETE_FROM_WORK_DIR "system" "$blob" &
done

BLOBS_LIST="
system/lib/libFace_Landmark_API.camera.samsung.so
system/lib/libsecjpeginterface.camera.samsung.so
system/lib/libface_landmark.arcsoft.so
system/lib64/libUltraWideDistortionCorrection.camera.samsung.so
system/lib64/libFacialBasedSelfieCorrection.camera.samsung.so
system/lib64/libhumantracking.arcsoft.so
system/lib64/libPortraitDistortionCorrectionCali.arcsoft.so
system/lib64/libface_landmark.arcsoft.so
system/lib64/libFacialStickerEngine.arcsoft.so
system/lib64/libveengine.arcsoft.so
system/lib64/libimage_enhancement.arcsoft.so
system/lib64/liblow_light_hdr.arcsoft.so
system/lib64/libobjectcapture_jni.arcsoft.so
system/lib64/libobjectcapture.arcsoft.so
system/lib64/libFacialAttributeDetection.arcsoft.so
system/lib64/libHpr_RecFace_dl_v1.0.camera.samsung.so
system/lib64/libSceneDetector_v1.camera.samsung.so
system/lib64/libPortraitDistortionCorrection.arcsoft.so
system/lib64/vendor.samsung_slsi.hardware.eden_runtime@1.0.so
system/lib64/libhigh_dynamic_range.arcsoft.so
system/lib64/libsnap_aidl.snap.samsung.so
system/lib64/vendor.samsung.hardware.snap-V3-ndk.so
system/lib64/libMyFilterPlugin.camera.samsung.so
system/lib64/libeden_wrapper_system.so
system/lib64/libFacePreProcessing_jni.camera.samsung.so
system/lib64/libsaiv_HprFace_cmh_support_jni.camera.samsung.so
system/lib64/libHprFace_GAE_jni.camera.samsung.so
system/lib64/libFace_Landmark_Engine.camera.samsung.so
system/lib64/libFaceRestoration.camera.samsung.so
system/lib64/libHprFace_GAE_api.camera.samsung.so
system/lib64/libFace_Landmark_API.camera.samsung.so
system/lib64/libImageTagger.camera.samsung.so
"

for blob in $BLOBS_LIST
do
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0" &
done

# shellcheck disable=SC2046
wait $(jobs -p) || exit 1
LOG_STEP_OUT

LOG "- Fixing portrait mode"
sed -i "s/ro.product.name/ro.unica.camera/g" "$WORK_DIR/system/system/lib64/libDualCamBokehCapture.camera.samsung.so"

LOG_STEP_IN "- Fixing AI Photo Editor"
cp -fa \
    "$WORK_DIR/system/system/cameradata/portrait_data/single_bokeh_feature.json" \
    "$WORK_DIR/system/system/cameradata/portrait_data/nexus_bokeh_feature.json"
SET_METADATA "system" "system/cameradata/portrait_data/nexus_bokeh_feature.json" 0 0 644 "u:object_r:system_file:s0"
sed -i "s/MODEL_TYPE_INSTANCE_CAPTURE/MODEL_TYPE_OBJ_INSTANCE_CAPTURE/g" \
    "$WORK_DIR/system/system/cameradata/portrait_data/single_bokeh_feature.json"
sed -i \
    's/system\/cameradata\/portrait_data\/single_bokeh_feature.json/system\/cameradata\/portrait_data\/nexus_bokeh_feature.json\x00/g' \
    "$WORK_DIR/system/system/lib64/libPortraitSolution.camera.samsung.so"
LOG_STEP_OUT
