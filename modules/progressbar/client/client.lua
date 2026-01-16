function BeginProgressBar()
    if not Config.ProgressBarEnabled then return end
    local success = Bridge.ProgressBar.Open({
        duration = 5000,
        label = locale("Progressbar.ProgressText"),
        disable = { move = true, combat = true },
        anim = { dict = "amb@prop_human_parking_meter@female@base", clip = "base_female", },
        flag = 49,
        canCancel = true,
    })
    return success
end