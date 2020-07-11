# Fixing the Force Dark problem on MIUI 12
This is a [Magisk](https://topjohnwu.github.io/Magisk/) module that fixes the problem with the force dark setting on Miui 12 by [Xiaomi.eu](https://xiaomi.eu/), this rom is deodexed so patching shouldn't be a problem. 

## Actual  changes made
In case you don't want to install random services.apk from the internet this will be an outline of the changes I made, and how I made them.
First I pulled /system/framework/services.apk from my phone the my pc. Then the baksmali program was used to dissasemble the apk and produce a folder with all the classes that were compiled inside of the apk. In the interest of this mod only one file had to be touched and this is UiModeManagerService.smali. After this file was modified the smali program was used to produce the nedded `classes.dex` file which could then be replaced inside of the original apk. Then you can recreate this module yourself and install it. A helpfull Makefile is probvided that can help with all of these steps. This exposed showes how this all can be done [hacker1024/MIUI-Global-Dark-Mode-Disabler](https://github.com/hacker1024/MIUI-Global-Dark-Mode-Disabler), all I did was to make these changes into smali code.

These are the exact changes for the referance:

com/android/server/UiModeManagerService.smali starting fomr line 1204:

```smali   
.method private setDarkProp(II)V
    .registers 6

    const/4 v0, 0x0

    const/4 v1, 0x2

    if-ne p1, v1, :cond_5

    const/4 v0, 0x1

    :cond_5
    invoke-virtual {p0}, Lcom/android/server/UiModeManagerService;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v1

    const-string v2, "dark_mode_enable"

    invoke-static {v1, v2, v0, p2}, Landroid/provider/Settings$System;->putIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)Z

    invoke-virtual {p0}, Lcom/android/server/UiModeManagerService;->getContext()Landroid/content/Context;

    # just put a return here so the rest of the cone won't get executed.
    # This is simpler when editing the smali then turning the options off after they were turned on as was done in the exposed module. 
    # The rest of the code can be removed but was left for clarity
    return-void

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v1

    const-string/jumbo v2, "smart_dark_enable"

    invoke-static {v1, v2, v0, p2}, Landroid/provider/Settings$System;->putIntForUser(Landroid/content/ContentResolver;Ljava/lang/String;II)Z

    const/4 v1, 0x1

    if-ne v0, v1, :cond_27

    const-string/jumbo v1, "true"

    goto :goto_29

    :cond_27
    const-string v1, "false"

    :goto_29
    const-string v2, "debug.hwui.force_dark"

    invoke-static {v2, v1}, Landroid/os/SystemProperties;->set(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

# This entire method's body was delted and replaced with a return, the amount of registers was changed to 2 idk, less wasted memory or sth.
.method private setForceDark(Landroid/content/Context;)V
    .registers 2
    return-void

.end method

```

