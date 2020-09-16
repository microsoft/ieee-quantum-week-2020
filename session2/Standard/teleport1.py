import qsharp
qsharp.reload()

## Import a shim to the program that we can simulate
from Test.Teleportation import RunProgram
RunProgram.simulate()
