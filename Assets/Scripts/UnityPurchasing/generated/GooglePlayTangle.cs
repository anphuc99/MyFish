// WARNING: Do not modify! Generated file.

namespace UnityEngine.Purchasing.Security {
    public class GooglePlayTangle
    {
        private static byte[] data = System.Convert.FromBase64String("6Q6Gb1sDrI/jOSg/EbHI8l+FfUveJG44DkWEWrn7xcS6OpL1dtR7ghZa3dts1EOsUyo+3m6aOUNG9H7Xc0JnYEmfGeAGzCkndNFB6COq5AzebO/M3uPo58RopmgZ4+/v7+vu7cD4F9Q5MoY/3Dy6qWGpJFOAp7/ZXnmGMnwZ0PWEtJw4M9r8+O2gtAkhALCLUNSA0nl/2Wv3SNg5DPYA37gx2BKPy2tVspfN6dSWHTWf5vx1LoNKSgHVpYMXYXW/BtW9PELdEQAJyKrzZ4DqFFe9CyyWmNuRWL5CAluwVjcFgSWrnHkwIwAFaXJFKFhHbO/h7t5s7+TsbO/v7nFDtvAdR1C791fZAzfcCkZbEaa++wOEoiju8F2F2QZreMy4f+zt7+7v");
        private static int[] order = new int[] { 11,6,12,12,11,12,11,12,9,12,10,12,12,13,14 };
        private static int key = 238;

        public static readonly bool IsPopulated = true;

        public static byte[] Data() {
        	if (IsPopulated == false)
        		return null;
            return Obfuscator.DeObfuscate(data, order, key);
        }
    }
}
