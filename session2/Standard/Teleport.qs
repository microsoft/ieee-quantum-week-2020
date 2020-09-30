// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

namespace Test.Teleportation {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Measurement;

    operation TeleportClassicalMessage (message : Bool) : Bool {
        using ((msg, target) = (Qubit(), Qubit())) {

            if (message) {
                X(msg);
            }

            using (register = Qubit()) {
                H(register);
                CNOT(register, target);
                CNOT(msg, register);
                H(msg);
                if (MResetZ(msg) == One) { Z(target); }
                if (IsResultOne(MResetZ(register))) { X(target); }
            }

            return MResetZ(target) == One;
        }
    }
}
