# getkey volume ("borrowed" from https://github.com/Zenlua/Overlayfs)
keyvolume() {
    keyvl=''
    keyvl=$(getevent -qlc 1 | awk '{print $3}')
    if [ "$keyvl" == "KEY_VOLUMEDOWN" ] || [ "$keyvl" == "ABS_MT_TRACKING_ID" ]; then
        echo 1
    elif [ "$keyvl" == "KEY_VOLUMEUP" ]; then
        echo 2
    elif [ "$keyvl" == "KEY_POWER" ]; then
        echo 3
    else
        keyvolume
    fi
}

ui_print " "
ui_print "***************************************************************************"
ui_print "*** Use the Vol-, Vol+ or Power buttons to make selection when prompted ***"
ui_print "***************************************************************************"
ui_print " "

# Clear the system.prop file
echo -n > $MODPATH/system.prop

ui_print ">>> DISPLAY TWEAKS <<<"
ui_print " "

ui_print "- Select DPI:"
ui_print "  [Vol-] 290 DPI (Recommended)"
ui_print "  [Vol+] 320 DPI"
ui_print "  [PWR ] 369 DPI (Stock)"
ui_print " "

if [ "$(keyvolume)" == 1 ]; then
    ui_print "- Setting DPI value to 290"
    ui_print " "
    echo "ro.sf.lcd_density=290" >> $MODPATH/system.prop
    settings put system font_scale 1.0
    wm density reset
elif [ "$(keyvolume)" == 2 ]; then
    ui_print "- Setting DPI value to 320"
    ui_print " "
    echo "ro.sf.lcd_density=320" >> $MODPATH/system.prop
    settings put system font_scale 1.0
    wm density reset
else
    ui_print "- DPI value unchanged"
    ui_print " "
    wm density reset
fi

sleep 2

ui_print "- Select system animation speed (1.0x is stock):"
ui_print "  [Vol-] 0.5x (Recommended)"
ui_print "  [Vol+] 1.0x (Stock)"
ui_print "  [PWR ] Off"
ui_print " "

if [ "$(keyvolume)" == 1 ]; then
    ui_print "- Setting animation speed to 0.5x"
    settings put global window_animation_scale 0.5
    settings put global transition_animation_scale 0.5
    settings put global animator_duration_scale 0.5
    ui_print " "
elif [ "$(keyvolume)" == 2 ]; then
    ui_print "- Setting animation speed to 1.0x (Stock)"
    settings put global window_animation_scale 1
    settings put global transition_animation_scale 1
    settings put global animator_duration_scale 1
    ui_print " "
else
    ui_print "- Disabling system animations"
    settings put global window_animation_scale 0
    settings put global transition_animation_scale 0
    settings put global animator_duration_scale 0
    ui_print " "
fi

sleep 2

ui_print ">>> AUDIO TWEAKS <<<"
ui_print " "

ui_print "- Apply Volume Fix?"
ui_print "  [Vol-] YES (Recommended)"
ui_print "  [Vol+] NO"
ui_print " "

if [ "$(keyvolume)" == 2 ]; then
    if [ -f "$MODPATH/system/vendor/etc/default_volume_tables.xml" ]; then
        mv $MODPATH/system/vendor/etc/default_volume_tables.xml $MODPATH/system/vendor/etc/default_volume_tables.off
    fi
    ui_print "- Volume fix disabled"
    ui_print " "
else
    if [ -f "$MODPATH/system/vendor/etc/default_volume_tables.off" ]; then
        mv $MODPATH/system/vendor/etc/default_volume_tables.off $MODPATH/system/vendor/etc/default_volume_tables.xml
    fi
    echo "audio.safemedia.bypass=true" >> $MODPATH/system.prop
    echo "ro.audio.ignore_effects=false" >> $MODPATH/system.prop
    ui_print "- Volume fix applied"
    ui_print " "
fi

sleep 2

ui_print "- Select Volume Steps:"
ui_print "  [Vol-] 50 steps (Recommended)"
ui_print "  [Vol+] 30 steps"
ui_print "  [PWR ] 15 steps (Stock)"
ui_print " "

if [ "$(keyvolume)" == 1 ]; then
    ui_print "- Setting volume steps to 50"
    ui_print " "
    echo "ro.config.media_vol_steps=50" >> $MODPATH/system.prop
elif [ "$(keyvolume)" == 2 ]; then
    ui_print "- Setting volume steps to 30"
    ui_print " "
    echo "ro.config.media_vol_steps=30" >> $MODPATH/system.prop
else
    ui_print "- Using stock volume steps value of 15"
    ui_print " "
fi

ui_print "- FINISHED! Reboot to apply changes."
ui_print " "
