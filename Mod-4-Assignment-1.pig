-- Load input from the file named Mary, and call the single 
-- field in the record 'sentence'.
A = load '/user/hadoop/input/Shakespeare.txt' as (sentence);

-- TOKENIZE splits the sentence into a field for each word.
-- flatten will take the collection of records returned by
-- TOKENIZE and produce a separate record for each one, calling the single
-- field in the record word.
B = foreach A generate flatten(TOKENIZE(sentence)) as word;

-- Now group them together by each word.
C  = group B by word;

-- Count them.
cntd  = foreach C generate group, COUNT(B);
-- Print out the results.
dump cntd;

-- Store result
STORE cntd into '/user/hadoop/output/pig_1/';