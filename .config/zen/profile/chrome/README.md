# zen-wabi dynamic theming setup

This instructions will be done quick so don't expect too much quality, just because it took me a lot of time to correctly setup it up. Maybe in the future I'll update it.

## Requirements

You need to install `fx-autoconfig`, for this go to their [Github page](https://github.com/MrOtherGuy/fx-autoconfig) and follow the instructions.

Then copy these folders into your respective Zen Browser default profile, you can check the path in 'about:profiles' (`~/.config/zen/<your-profile>/chrome/`). All of these files were created by [parazeeknova](https://github.com/parazeeknova).

If your zen config file is instead in `~/.zen/` then you must update it, to do this follow these steps:

1. Create a backup of your default profile (only if you care of not losing your settings): `cp -r ~/.zen/<profile>/* ~/profile-backup/`
2. Close all instances of zen.
3. Delete the zen config folder: `rm -rf ~/.zen/`
4. Open zen. This will now create the new config folder for zen at `~/.config/zen`. Make sure to take note of the name for the new default profile that was created.
5. Now delete the new default profile: `rm -rf ~/.config/zen/<default-profile>/`
6. Replace it with the profile backup (remember to use the new default profile name for the folder): `cp -r ~/profile-backup/ ~/.config/zen/<default-profile>`.

Now that the profile is migrated to the new version you can paste the folders.

Then follow the zen-wabi tutorial from [step 3](https://github.com/parazeeknova/zen-wabi/tree/main#3-install-fx-autoconfig).

Matugen should do the rest after that.

