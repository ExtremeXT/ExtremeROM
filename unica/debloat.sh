#
# Copyright (C) 2023 Salvo Giangreco
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# UN1CA debloat list
# - Add entries inside the specific partition containing that file (<PARTITION>_DEBLOAT+="")
# - DO NOT add the partition name at the start of any entry (eg. "/system/dpolicy_system")
# - DO NOT add a slash at the start of any entry (eg. "/dpolicy_system")

# Samsung Defex policy
SYSTEM_DEBLOAT+="
dpolicy_system
"
VENDOR_DEBLOAT+="
etc/dpolicy
"

# Samsung SIM Unlock
SYSTEM_DEBLOAT+="
system/bin/ssud
system/etc/init/ssu_pa3qxxx.rc
system/etc/init/ssu.rc
system/etc/permissions/privapp-permissions-com.samsung.ssu.xml
system/etc/sysconfig/samsungsimunlock.xml
system/lib64/android.security.securekeygeneration-ndk.so
system/lib64/vendor.samsung.hardware.security.ssu-V1-ndk.so
system/lib64/libssu_keystore2.so
system/priv-app/SsuService
"

# Recovery restoration script
VENDOR_DEBLOAT+="
recovery-from-boot.p
bin/install-recovery.sh
etc/init/vendor_flash_recovery.rc
"

# SEPolicy version
VENDOR_DEBLOAT+="
etc/selinux/vendor_sepolicy_version
"

# Apps debloat
PRODUCT_DEBLOAT+="
app/AssistantShell
app/Chrome64
app/Duo
app/Gmail2
app/Maps
app/Photos
app/YouTube
overlay/GmsConfigOverlaySearchSelector.apk
priv-app/Messages
priv-app/SearchSelector
"

SYSTEM_DEBLOAT+="
system/app/CarrierDefaultApp
system/app/ccinfo
system/app/ChromeCustomizations
system/app/Fast
system/app/FBAppManager_NS
system/app/KidsHome_Installer
system/app/MAPSAgent
system/app/MDMApp
system/app/PlayAutoInstallConfig
system/app/Rampart
system/app/SamsungCarKeyFw
system/app/SamsungPassAutofill_v1
system/app/SamsungTTSVoice_ar_AE_m00_ICLM
system/app/SamsungTTSVoice_de_DE_f00
system/app/SamsungTTSVoice_en_GB_f00
system/app/SamsungTTSVoice_es_ES_f00
system/app/SamsungTTSVoice_es_MX_f00_ICLM
system/app/SamsungTTSVoice_es_US_f00
system/app/SamsungTTSVoice_fr_FR_f00
system/app/SamsungTTSVoice_hi_IN_f00_ICLM
system/app/SamsungTTSVoice_id_ID_f00_ICLM
system/app/SamsungTTSVoice_it_IT_f00
system/app/SamsungTTSVoice_pl_PL_f00
system/app/SamsungTTSVoice_pt_BR_f00
system/app/SamsungTTSVoice_ru_RU_f00
system/app/SamsungTTSVoice_th_TH_f00
system/app/SamsungTTSVoice_vi_VN_f00
system/app/SilentLog
system/app/SimAppDialog
system/app/Traceur
system/app/UniversalMDMClient
system/app/WebManual
system/app/WifiGuider
system/etc/default-permissions/default-permissions-com.sec.spp.push.xml
system/etc/init/digitalkey_init_nfc_tss2.rc
system/etc/init/samsung_pass_authenticator_service.rc
system/etc/permissions/authfw.xml
system/etc/permissions/com.samsung.feature.ipsgeofence.xml
system/etc/permissions/com.samsung.feature.samsungpositioning.xml
system/etc/permissions/org.carconnectivity.android.digitalkey.rangingintent.xml
system/etc/permissions/org.carconnectivity.android.digitalkey.secureelement.xml
system/etc/permissions/privapp-permissions-com.microsoft.skydrive.xml
system/etc/permissions/privapp-permissions-com.samsung.android.app.updatecenter.xml
system/etc/permissions/privapp-permissions-com.samsung.android.authfw.xml
system/etc/permissions/privapp-permissions-com.samsung.android.carkey.xml
system/etc/permissions/privapp-permissions-com.samsung.android.dkey.xml
system/etc/permissions/privapp-permissions-com.samsung.android.ipsgeofence.xml
system/etc/permissions/privapp-permissions-com.samsung.android.samsungpass.xml
system/etc/permissions/privapp-permissions-com.samsung.android.samsungpositioning.xml
system/etc/permissions/privapp-permissions-com.samsung.android.spayfw.xml
system/etc/permissions/privapp-permissions-com.samsung.oda.service.xml
system/etc/permissions/privapp-permissions-com.sec.android.diagmonagent.xml
system/etc/permissions/privapp-permissions-com.sec.android.soagent.xml
system/etc/permissions/privapp-permissions-com.sec.bcservice.xml
system/etc/permissions/privapp-permissions-com.sec.cpagent.xml
system/etc/permissions/privapp-permissions-com.sec.imslogger.xml
system/etc/permissions/privapp-permissions-com.sec.spp.push.xml
system/etc/permissions/privapp-permissions-com.skms.android.agent.xml
system/etc/permissions/privapp-permissions-com.wssyncmldm.xml
system/etc/permissions/privapp-permissions-meta.xml
system/etc/PF_TA
system/etc/sysconfig/digitalkey.xml
system/etc/sysconfig/meta-hiddenapi-package-allowlist.xml
system/etc/sysconfig/preinstalled-packages-com.samsung.android.dkey.xml
system/etc/sysconfig/preinstalled-packages-com.samsung.android.spayfw.xml
system/etc/sysconfig/samsungauthframework.xml
system/etc/sysconfig/samsungpassapp.xml
system/etc/sysconfig/samsungpushservice.xml
system/hidden/SmartTutor
system/preload/Facebook_stub_preload
system/priv-app/AppUpdateCenter
system/priv-app/AREmoji
system/priv-app/AREmojiEditor
system/priv-app/AuthFramework
system/priv-app/BCService
system/priv-app/CpAgent
system/priv-app/DiagMonAgent94
system/priv-app/DigitalKey
system/priv-app/EnhancedAttestationAgent
system/priv-app/FBInstaller_NS
system/priv-app/FBServices
system/priv-app/FotaAgent
system/priv-app/ImsLogger
system/priv-app/IpsGeofence
system/priv-app/OdaService
system/priv-app/OMCAgent5
system/priv-app/OneDrive_Samsung_v3
system/priv-app/PaymentFramework
system/priv-app/SamsungCarKeyFw
system/priv-app/SamsungPass
system/priv-app/SamsungPositioning
system/priv-app/SKMSAgent
system/priv-app/SOAgent75
system/priv-app/SPPPushClient
system/priv-app/StickerFaceARAvatar
system/priv-app/YourPhone_P1_5
"

PRISM_DEBLOAT+="
app
media
preload
priv-app
sipdb/Xt9
sipdb/SwiftKey/ar
sipdb/SwiftKey/as
sipdb/SwiftKey/az
sipdb/SwiftKey/be
sipdb/SwiftKey/bg
sipdb/SwiftKey/bn
sipdb/SwiftKey/cs
sipdb/SwiftKey/da
sipdb/SwiftKey/de
sipdb/SwiftKey/el
sipdb/SwiftKey/en_au
sipdb/SwiftKey/en_gb
sipdb/SwiftKey/en_in
sipdb/SwiftKey/es_es
sipdb/SwiftKey/es_us
sipdb/SwiftKey/et
sipdb/SwiftKey/fa
sipdb/SwiftKey/fi
sipdb/SwiftKey/fr_fr
sipdb/SwiftKey/gu
sipdb/SwiftKey/he
sipdb/SwiftKey/hi
sipdb/SwiftKey/hr
sipdb/SwiftKey/hu
sipdb/SwiftKey/hy
sipdb/SwiftKey/id
sipdb/SwiftKey/is
sipdb/SwiftKey/it
sipdb/SwiftKey/jv_id
sipdb/SwiftKey/ka
sipdb/SwiftKey/kk
sipdb/SwiftKey/km
sipdb/SwiftKey/kn
sipdb/SwiftKey/ko
sipdb/SwiftKey/ky
sipdb/SwiftKey/lo
sipdb/SwiftKey/lt
sipdb/SwiftKey/lv
sipdb/SwiftKey/mk
sipdb/SwiftKey/ml
sipdb/SwiftKey/mn
sipdb/SwiftKey/mr
sipdb/SwiftKey/ms
sipdb/SwiftKey/my_mm
sipdb/SwiftKey/my_zg
sipdb/SwiftKey/nb
sipdb/SwiftKey/ne
sipdb/SwiftKey/nl
sipdb/SwiftKey/or
sipdb/SwiftKey/pa
sipdb/SwiftKey/pl
sipdb/SwiftKey/pt_br
sipdb/SwiftKey/pt_pt
sipdb/SwiftKey/ro
sipdb/SwiftKey/ru
sipdb/SwiftKey/si
sipdb/SwiftKey/sk
sipdb/SwiftKey/sl
sipdb/SwiftKey/sq
sipdb/SwiftKey/sr
sipdb/SwiftKey/su_id
sipdb/SwiftKey/sv
sipdb/SwiftKey/szl
sipdb/SwiftKey/ta
sipdb/SwiftKey/te
sipdb/SwiftKey/tg
sipdb/SwiftKey/th
sipdb/SwiftKey/tk
sipdb/SwiftKey/tl
sipdb/SwiftKey/tr
sipdb/SwiftKey/uk
sipdb/SwiftKey/ur
sipdb/SwiftKey/uz
sipdb/SwiftKey/vi
HWRDB/data/hwr_ar.dat
HWRDB/data/hwr_az_AZ.dat
HWRDB/data/hwr_bg_BG.dat
HWRDB/data/hwr_bn_BD.dat
HWRDB/data/hwr_cs_CZ.dat
HWRDB/data/hwr_da_DK.dat
HWRDB/data/hwr_de_DE.dat
HWRDB/data/hwr_el_GR.dat
HWRDB/data/hwr_en_AU.dat
HWRDB/data/hwr_en_GB.dat
HWRDB/data/hwr_es_ES.dat
HWRDB/data/hwr_es_US.dat
HWRDB/data/hwr_et_EE.dat
HWRDB/data/hwr_fa_IR.dat
HWRDB/data/hwr_fi_FI.dat
HWRDB/data/hwr_fr_FR.dat
HWRDB/data/hwr_he_IL.dat
HWRDB/data/hwr_hi_IN.dat
HWRDB/data/hwr_hr_HR.dat
HWRDB/data/hwr_hu_HU.dat
HWRDB/data/hwr_hy_AM.dat
HWRDB/data/hwr_id_ID.dat
HWRDB/data/hwr_is_IS.dat
HWRDB/data/hwr_it_IT.dat
HWRDB/data/hwr_kk_KZ.dat
HWRDB/data/hwr_ko_KR.dat
HWRDB/data/hwr_ky_KG.dat
HWRDB/data/hwr_lt_LT.dat
HWRDB/data/hwr_lv_LV.dat
HWRDB/data/hwr_mk_MK.dat
HWRDB/data/hwr_mn_MN.dat
HWRDB/data/hwr_mr_IN.dat
HWRDB/data/hwr_ms_MY.dat
HWRDB/data/hwr_nb_NO.dat
HWRDB/data/hwr_nl_NL.dat
HWRDB/data/hwr_pl_PL.dat
HWRDB/data/hwr_pt_BR.dat
HWRDB/data/hwr_pt_PT.dat
HWRDB/data/hwr_ro_RO.dat
HWRDB/data/hwr_ru_RU.dat
HWRDB/data/hwr_sk_SK.dat
HWRDB/data/hwr_sl_SI.dat
HWRDB/data/hwr_sq_AL.dat
HWRDB/data/hwr_sr_Latn_RS.dat
HWRDB/data/hwr_sv_SE.dat
HWRDB/data/hwr_ta_IN.dat
HWRDB/data/hwr_tg_TJ.dat
HWRDB/data/hwr_th_TH.dat
HWRDB/data/hwr_tk_TM.dat
HWRDB/data/hwr_tr_TR.dat
HWRDB/data/hwr_uk_UA.dat
HWRDB/data/hwr_ur_PK.dat
HWRDB/data/hwr_uz_UZ.dat
HWRDB/data/hwr_vi_VN.dat
HWRDB/data/hwr_zh_CN.dat
HWRDB/data/hwr_zh_HK.dat
HWRDB/data/hwr_zh_TW.dat
"

# eSIM
if $SOURCE_IS_ESIM_SUPPORTED; then
    if ! $TARGET_IS_ESIM_SUPPORTED; then
        SYSTEM_DEBLOAT+="
        system/etc/permissions/privapp-permissions-com.samsung.android.app.esimkeystring.xml
        system/etc/permissions/privapp-permissions-com.samsung.euicc.mep.xml
        system/etc/sysconfig/preinstalled-packages-com.samsung.android.app.esimkeystring.xml
        system/etc/sysconfig/preinstalled-packages-com.samsung.euicc.xml
        system/priv-app/EsimKeyString
        system/priv-app/EsimClient
        system/priv-app/EuiccService
        "
    fi
fi
