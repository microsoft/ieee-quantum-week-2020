using System.IO;
using System.Threading.Tasks;
using Microsoft.Quantum.Simulation.Simulators;

namespace ResourceEstimation
{
    public class Simulator : ResourcesEstimator
    {
        public override Task<O> Run<T, I, O>(I args)
        {
            var result = base.Run<T, I, O>(args).Result;
            var name = typeof(T).Name;
            File.WriteAllText($"{name}.txt", ToTSV());
            return Task.Run(() => result);
        }
    }
}
