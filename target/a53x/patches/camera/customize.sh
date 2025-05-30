LOG_STEP_IN
LOG "- Fix portrait mode"
BLOBS_LIST="
system/etc/public.libraries-arcsoft.txt
system/lib/libface_landmark.arcsoft.so
system/lib64/libhumantracking.arcsoft.so
system/lib64/libPortraitDistortionCorrection.arcsoft.so
system/lib64/libPortraitDistortionCorrectionCali.arcsoft.so
system/lib64/libface_landmark.arcsoft.so
system/lib64/libFacialStickerEngine.arcsoft.so
system/lib64/libfrtracking_engine.arcsoft.so
system/lib64/libFaceRecognition.arcsoft.so
system/lib64/libveengine.arcsoft.so
system/lib64/lib_pet_detection.arcsoft.so
system/lib64/libae_bracket_hdr.arcsoft.so
system/lib64/libhigh_res.arcsoft.so
system/lib64/libhybrid_high_dynamic_range.arcsoft.so
system/lib64/libimage_enhancement.arcsoft.so
system/lib64/liblow_light_hdr.arcsoft.so
system/lib64/libhigh_dynamic_range.arcsoft.so
system/lib64/libsuperresolution_raw.arcsoft.so
system/lib64/libobjectcapture_jni.arcsoft.so
system/lib64/libFacialAttributeDetection.arcsoft.so
system/lib64/libobjectcapture.arcsoft.so
"
for blob in $BLOBS_LIST
do
    DELETE_FROM_WORK_DIR "system" "$blob"
done

BLOBS_LIST="
system/etc/public.libraries-arcsoft.txt
system/lib/libface_landmark.arcsoft.so
system/lib64/libhumantracking.arcsoft.so
system/lib64/libPortraitDistortionCorrection.arcsoft.so
system/lib64/libPortraitDistortionCorrectionCali.arcsoft.so
system/lib64/libface_landmark.arcsoft.so
system/lib64/libFacialStickerEngine.arcsoft.so
system/lib64/libimage_enhancement.arcsoft.so
system/lib64/libveengine.arcsoft.so
system/lib64/liblow_light_hdr.arcsoft.so
system/lib64/libhigh_dynamic_range.arcsoft.so
system/lib64/libobjectcapture_jni.arcsoft.so
system/lib64/libobjectcapture.arcsoft.so
system/lib64/libFacialAttributeDetection.arcsoft.so
"
for blob in $BLOBS_LIST
do
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "$blob" 0 0 644 "u:object_r:system_lib_file:s0"
done

LOG "- Fix AI Photo Editor"
cp -a --preserve=all \
    "$SRC_DIR/prebuilts/samsung/a52qnsxx/system/cameradata/portrait_data/single_bokeh_feature.json" \
    "$WORK_DIR/system/system/cameradata/portrait_data/unica_bokeh_feature.json"
SET_METADATA "system" "system/cameradata/portrait_data/unica_bokeh_feature.json" 0 0 644 "u:object_r:system_file:s0"
sed -i "s/MODEL_TYPE_INSTANCE_CAPTURE/MODEL_TYPE_OBJ_INSTANCE_CAPTURE/g" \
    "$WORK_DIR/system/system/cameradata/portrait_data/single_bokeh_feature.json"
sed -i \
    's/system\/cameradata\/portrait_data\/single_bokeh_feature.json/system\/cameradata\/portrait_data\/unica_bokeh_feature.json\x00/g' \
    "$WORK_DIR/system/system/lib64/libPortraitSolution.camera.samsung.so"
LOG_STEP_OUT
