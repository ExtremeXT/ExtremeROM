echo "- Fix portrait mode"
DELETE_FROM_WORK_DIR "system" "system/etc/public.libraries-arcsoft.txt"
BLOBS_LIST="
libhumantracking.arcsoft.so
libface_recognition.arcsoft.so
libsuper_fusion.arcsoft.so
libsf_tetra_enhance.arcsoft.so
libmf_bayer_enhance.arcsoft.so
libpic_best.arcsoft.so
libPortraitDistortionCorrection.arcsoft.so
libPortraitDistortionCorrectionCali.arcsoft.so
libface_landmark.arcsoft.so
libFacialStickerEngine.arcsoft.so
libfrtracking_engine.arcsoft.so
libFaceRecognition.arcsoft.so
libveengine.arcsoft.so
lib_pet_detection.arcsoft.so
libae_bracket_hdr.arcsoft.so
libhybrid_high_dynamic_range.arcsoft.so
libimage_enhancement.arcsoft.so
libhigh_dynamic_range.arcsoft.so
libobjectcapture_jni.arcsoft.so
libFacialAttributeDetection.arcsoft.so
libobjectcapture.arcsoft.so
libai_fusion_high_resolution.arcsoft.so
libai_fusion_high_resolution_base_v2.arcsoft.so
libai_fusion_high_resolution_base_v1.arcsoft.so
"
for blob in $BLOBS_LIST
do
    DELETE_FROM_WORK_DIR "system" "system/lib64/$blob"
done

ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/etc/public.libraries-arcsoft.txt" 0 0 644 "u:object_r:system_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib/libface_landmark.arcsoft.so" 0 0 644 "u:object_r:system_lib_file:s0"
BLOBS_LIST="
libhumantracking.arcsoft.so
libPortraitDistortionCorrection.arcsoft.so
libPortraitDistortionCorrectionCali.arcsoft.so
libface_landmark.arcsoft.so
libFacialStickerEngine.arcsoft.so
libimage_enhancement.arcsoft.so
libveengine.arcsoft.so
liblow_light_hdr.arcsoft.so
libobjectcapture_jni.arcsoft.so
libobjectcapture.arcsoft.so
libFacialAttributeDetection.arcsoft.so
"
for blob in $BLOBS_LIST
do
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/$blob" 0 0 644 "u:object_r:system_lib_file:s0"
done

echo "- Fix AI Photo Editor"
cp -a --preserve=all \
    "$SRC_DIR/target/$TARGET_CODENAME/patches/camera/system/cameradata/portrait_data/single_bokeh_feature.json" \
    "$WORK_DIR/system/system/cameradata/portrait_data/unica_bokeh_feature.json"
SET_METADATA "system" "system/cameradata/portrait_data/unica_bokeh_feature.json" 0 0 644 "u:object_r:system_file:s0"
sed -i "s/MODEL_TYPE_INSTANCE_CAPTURE/MODEL_TYPE_OBJ_INSTANCE_CAPTURE/g" \
    "$WORK_DIR/system/system/cameradata/portrait_data/single_bokeh_feature.json"
sed -i \
    's/system\/cameradata\/portrait_data\/single_bokeh_feature.json/system\/cameradata\/portrait_data\/unica_bokeh_feature.json\x00/g' \
    "$WORK_DIR/system/system/lib64/libPortraitSolution.camera.samsung.so"
