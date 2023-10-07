import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.apache.pig.EvalFunc;
import org.apache.pig.data.Tuple;

public class WordFrequency extends EvalFunc<Map<String, Integer>> {
    public Map<String, Integer> exec(Tuple input) throws IOException {
        if (input == null || input.size() == 0)
            return null;
        try {
            Map<String, Integer> wordMap = new HashMap<String, Integer>();
            String line = (String) input.get(0);
            String[] words = line.split("\\s+");
            for (String word : words) {
                if (wordMap.containsKey(word)) {
                    wordMap.put(word, wordMap.get(word) + 1);
                } else {
                    wordMap.put(word, 1);
                }
            }
            return wordMap;
        } catch (Exception e) {
            throw new IOException("Caught exception processing input row ", e);
        }
    }
}
