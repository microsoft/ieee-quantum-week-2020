namespace ResourceEstimation {
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Logical;
    open Microsoft.Quantum.Measurement;

    @Test("ToffoliSimulator")
    operation ExhaustiveCCNOTSimulation() : Unit {
        let IsTrue = EqualB(true, _);

        for (i in 0..7) {
            using ((x1, x2, x3, y) = (Qubit(), Qubit(), Qubit(), Qubit())) {
                within {
                    ApplyXorInPlace(i, LittleEndian([x1, x2, x3]));
                } apply {
                    ApplyMajorityUsingCCNOTs(x1, x2, x3, y);
                    let result = IsResultOne(MResetZ(y));
                    EqualityFactB(result, i == 3 or (i >= 5 and i <= 7), $"Unexpected result for assignment {i}");
                }
            }
        }
    }

    @Test("QuantumSimulator")
    operation CheckEquivalence() : Unit {
        AssertMajorityOperationsEqual(ApplyMajorityUsingInts, ApplyMajorityUsingCCNOTs);
        AssertMajorityOperationsEqual(ApplyMajorityUsingCCNOTs, ApplyMajorityUsingTruthTable);
        AssertMajorityOperationsEqual(ApplyMajorityUsingTruthTable, ApplyMajorityUsingCNOTTransformation);
    }

    @Test("ResourceEstimation.Simulator")
    operation UsingInts() : Unit {
        using ((x1, x2, x3, y) = (Qubit(), Qubit(), Qubit(), Qubit())) {
            ApplyMajorityUsingInts(x1, x2, x3, y);
        }
    }

    @Test("ResourceEstimation.Simulator")
    operation UsingCCNOTs() : Unit {
        using ((x1, x2, x3, y) = (Qubit(), Qubit(), Qubit(), Qubit())) {
            ApplyMajorityUsingCCNOTs(x1, x2, x3, y);
        }
    }

    @Test("ResourceEstimation.Simulator")
    operation UsingTruthTable() : Unit {
        using ((x1, x2, x3, y) = (Qubit(), Qubit(), Qubit(), Qubit())) {
            ApplyMajorityUsingTruthTable(x1, x2, x3, y);
        }
    }

    @Test("ResourceEstimation.Simulator")
    operation UsingCNOTTransformation() : Unit {
        using ((x1, x2, x3, y) = (Qubit(), Qubit(), Qubit(), Qubit())) {
            ApplyMajorityUsingCNOTTransformation(x1, x2, x3, y);
        }
    }

    internal operation ApplyToFirstFourQubitsA(op : ((Qubit, Qubit, Qubit, Qubit) => Unit is Adj), qubits : Qubit[])
    : Unit is Adj {
        Fact(Length(qubits) >= 4, "Qubit array must have at least four elements");
        op(qubits[0], qubits[1], qubits[2], qubits[3]);
    }

    internal operation AssertMajorityOperationsEqual(op1 : ((Qubit, Qubit, Qubit, Qubit) => Unit is Adj), op2 : ((Qubit, Qubit, Qubit, Qubit) => Unit is Adj)) : Unit {
        AssertOperationsEqualReferenced(4,
            ApplyToFirstFourQubitsA(op1, _),
            ApplyToFirstFourQubitsA(op2, _)
        );
    }
}
