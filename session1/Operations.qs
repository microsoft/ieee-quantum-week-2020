// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
//
// Modified from code sample from the book "Learn Quantum Computing with Python and Q#" by
// Sarah Kaiser and Chris Granade, published by Manning Publications Co.
// Book ISBN 9781617296130.

namespace Microsoft.Quantum.Samples.IEEEQuantumWeek { 
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Arithmetic;

    open Microsoft.Quantum.Preparation;                              
    open Microsoft.Quantum.Math;

    operation ReflectAboutInitialState(
        prepareInitialState : (Qubit[] => Unit is Adj),
        register : Qubit[]
    )
    : Unit {
        within {
            Adjoint prepareInitialState(register);
            ApplyToEachCA(X, register);                                 
        } apply {
            Controlled Z(Most(register), Tail(register));
        }
    }

    operation ReflectAboutMarkedState(
        markedItemOracle : ((Qubit[], Qubit) => Unit is Adj),
        inputQubits : Qubit[]
    )
    : Unit is Adj {
        using (flag = Qubit()) {
            within {
                X(flag);
                H(flag);
            } apply{
                markedItemOracle(inputQubits, flag);
            }
        }
    }

    function NIterations(nQubits : Int) : Int {
        let nItems = 1 <<< nQubits;
        let angle = ArcSin(1. / Sqrt(IntAsDouble(nItems)));
        let nIterations = Round(0.25 * PI() / angle - 0.5);
        return nIterations;
    }

}
