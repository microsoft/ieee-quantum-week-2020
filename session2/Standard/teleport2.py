import qsharp
## Compile the program directly
teleport = qsharp.compile("""
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
""")

assert teleport.simulate(message=True)
assert not teleport.simulate(message=False)
