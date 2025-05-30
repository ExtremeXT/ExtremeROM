echo "- Fix camera notch position"
FOLDER_LIST="
DisplayCutoutEmulationCorner
DisplayCutoutEmulationDouble
DisplayCutoutEmulationHole
DisplayCutoutEmulationTall
DisplayCutoutEmulationWaterfall
"

for folder in $FOLDER_LIST
do
    DELETE_FROM_WORK_DIR "product" "overlay/$folder"
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "product" "overlay/$folder" 0 0 755 "u:object_r:system_file:s0"
done
