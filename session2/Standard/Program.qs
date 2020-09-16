// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

namespace Test.Teleportation {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Random;

    @EntryPoint()
    operation RunProgram () : Unit {
     
        for (idxRun in 1 .. 8) {
            let sent = DrawCategorical([0.5, 0.5]) == 0;
            let received = TeleportClassicalMessage(sent);
            Message($"Round {idxRun}: Sent {sent}, got {received}.");
            Message(sent == received ? "Teleportation successful!" | "");
        }
        
    }
}
