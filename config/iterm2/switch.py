#!/usr/bin/env python3

import asyncio
import iterm2
import logging

async def update(connection, theme):
    # Themes have space-delimited attributes, one of which will be light or dark.
    parts = theme.split(" ")
    logger = logging.getLogger('macos_theme_sync')
    logger.info("test 123")
    if "dark" in parts:
        preset = await iterm2.ColorPreset.async_get(connection, "dark")
        logger.info('Initial theme is dark')
    else:
        preset = await iterm2.ColorPreset.async_get(connection, "BlulocoLight")
        logger.info('Initial theme is light')

    # Update the list of all profiles and iterate over them.
    profiles=await iterm2.PartialProfile.async_query(connection)
    for partial in profiles:
        # Fetch the full profile and then set the color preset in it.
        profile = await partial.async_get_full_profile()
        await profile.async_set_color_preset(preset)

async def main(connection):
    app = await iterm2.async_get_app(connection)
    await update(connection, await app.async_get_variable("effectiveTheme"))
    async with iterm2.VariableMonitor(connection, iterm2.VariableScopes.APP, "effectiveTheme", None) as mon:
        while True:
            # Block until theme changes
            theme = await mon.async_get()
            await update(connection, theme)


iterm2.run_forever(main)
