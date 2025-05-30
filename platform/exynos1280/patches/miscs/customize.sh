# Fix Edge lighting corner radius
MODEL=$(LOG -n "$TARGET_FIRMWARE" | cut -d "/" -f 1)
SET_PROP "system" "ro.factory.model" "$MODEL"
