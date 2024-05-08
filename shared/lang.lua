Lang = {
    --server
    Changed = { title = "Vehicle Plate", msg = "The license plate has been changed to", status = "success", timeout = 5000, position = "right-center", icon = "fas fa-car" },
    FailedTaken = { title = "Vehicle Plate", msg = "This plate already exists.", status = "error", timeout = 5000, position = "right-center", icon = "fas fa-car" },
    FailedNotOwned = { title = "Vehicle Plate", msg = "You Dont Own This Vehicle.", status = "error", timeout = 5000, position = "right-center", icon = "fas fa-car" },
    NoPlateProvided = { title = "Vehicle Plate", msg = "No Plate Provided.", status = "error", timeout = 5000, position = "right-center", icon = "fas fa-car" },
    ToFarFromVeh = { title = "Vehicle Plate", msg = "You are not close enough to a vehicle.", status = "error", timeout = 5000, position = "right-center", icon = "fas fa-car" },
    NoInputPresent = { title = "Vehicle Plate", msg = "You haven't submitted any data.", status = "error", timeout = 5000, position = "right-center", icon = "fas fa-car" },
    BadWordUsed = { title = "Vehicle Plate", msg = "You are attempting to use a word on the word filter.", status = "error", timeout = 5000, position = "right-center", icon = "fas fa-car" },
    PlateChangeCanceled = { title = "Vehicle Plate", msg = "You Have Canceled The Plate Change.", status = "error", timeout = 5000, position = "right-center", icon = "fas fa-car" },
    InputMenuDumb = { title = "Vehicle Plate", msg = "You havent filled out the plate info.", status = "error", timeout = 5000, position = "right-center", icon = "fas fa-car" },
    NumberLetter = { title = "Vehicle Plate", msg = "You can only use numbers and letters.", status = "error", timeout = 5000, position = "right-center", icon = "fas fa-car" },
    MinMaxChars = { title = "Vehicle Plate", msg = "You must use at least "..Config.MinNumbers.." characters and less than "..Config.MaxNumbers, status = "error", timeout = 5000, position = "right-center", icon = "fas fa-car" },
    ProgressLabel = "Changing Plate",

}