# ARITIFICAL INTELLIGENCE
- https://medium.com/@machadogj/ml-basics-supervised-unsupervised-and-reinforcement-learning-b18108487c5a
- machine learning = using data directly to determine how a model behaves
    - as opposed to explicitly design procedure (e.g. write code) to define how a model behaves, early days of AI did this
    - regression is sorta machine learning, data used to create a function that fits the data(e.g. linear) and use function for predictions
    - models are just a bunch of tunable parmeters, in case of linear regression just 2 params (slope and y-intercept)
- deep learning - machine learning using many layers of neural networks to train a model
    - each layer of "nuerons" essentially doin matrix multiplication on output vector/matrix from previous layer
- TPUs made trasformers feasible
- prompt - in AI parlance it means a set of instructions or questions given to an AI system to elicit a different type of response
    - i.e. how to ask AI something in a way to get what you want
- vibe coding - conversation human-in-loop interaction with AI to do stuff
- agentic coding - more autonomous than vibe coding

## CODING AGENTS
- github copilot - propietary coding agent built for pair programming and tight integration into editors
- opencode - opensource CLI coding agent written in typscript
- crush - a fork of opencode, written in go
- claude code - propietary cli by anthropic for claude only
    - good 2026 claude vs opencode comparison - https://www.builder.io/blog/opencode-vs-claude-code

## PROTOCOLS
- MCP - model context protocol
    - https://modelcontextprotocol.io/docs/getting-started/intro

## LEARNING RESOURCES
- https://brilliant.org/courses/

## NEURAL NETWORKS
- a "neuron" holds a number, and is "activated" by neurons in other layers
- each neuron is connected to neurons in previous layer and to neurons in next layer, each connection has a weight
- deep NN - using many NN layers, often hundred to thousands
- feeforward NN - data flows only one direction, input -> layers -> output
- CNN - convolution NN, is feedforward, commonly used in deep learning NN
- RNN - Recurrent NN, is bidirectional and not feedforward

## REINFORCEMENT LEARNING
- give AI model a goal(a reward criteria), and throught constant iterations of trial and error get better at reaching the goal
- AlphaGo, Lee and Master, was first trained on top human player games, then rounds of self-training
    - AlphaGo Zero, had zero initial human game traing, was pure reinforcement learning, and surpassed AlphaGo Lee and Master

## LLM
- nov'24 - good vid on LLM transformers - https://www.youtube.com/watch?v=wjZofJX0v4M&list=WL&ab_channel=3Blue1Brown
- good LLM read: https://writings.stephenwolfram.com/2023/02/what-is-chatgpt-doing-and-why-does-it-work/
- common datasets
    - https://en.wikipedia.org/wiki/Common_Crawl - org that crawls web and curates/filters data from internet
    - Wikipedia corpus - all knowledge from wikipedia
- most, including chatGPT are autoregressive, try to predict next word based on what previous words are
    - GPT3 has like ~50k words in dictionary, output is vector of probability for each word based on previous words
    - first nnet layer is embedding matrix, 50k columns, each column represents a word from dictionary
        - "embedding" here means thinking of words are vectors in some high dimensional space, GPT3 has 12300 dimensions
        - so matrix size = 12300dimenions x 50000words
        - trained model tends to embed similar words(same semantic meaning) in the same direction
        - same with differences, the diff vector of king and queen will be near equal to diff vector of man and woman
            - model in this case choose to use a dimension to encode gender information
    - attention and MLP layers modify words to soak in position and context, GPT3 has max context size of 2048
        - MLPs and facts - https://www.youtube.com/watch?v=9-Jl0dxWQs8&list=WL&index=5&ab_channel=3Blue1Brown
            - MLPs basically kinda embed facts
    - unembedding matrix is last layer that transforms tokens to words, predictively using probability
- ReLU - rectified linear unit - makes negative numbers 0, positive numbers same
- softmax - a function that transforms set of values to a discrete probability distribution (total sums to 1)
    - summary it takes e to power of number and divides by that sum
    - temperature, exponent modifier T to change bias, T of zero means largest # will have near 1 probability
    - generally temp of GPT3 is set to 2, high temps are more original but can get nonsensical fast
- great video by kaparthy(former tesla AI chief) - https://www.youtube.com/watch?v=zjkBMFhNj_g&t=453s&ab_channel=AndrejKarpathy
     - we know the architecture and exact equations/params and know outtput is predicting better as we train
        - but we dont know how the params "interact" or change in order to do this
    - many of these LLMs like chatGPT can use external tools 
        - web browser to search and generate response on the search results
        - a calculator for math, python REPL, generate a chart, Dall-E for image generation, etc
- neural networks composed of transformer layers, attention layers, multi-layer perceptrons(MLP)
    - generally we think "facts" live in the MLPs
- the weights/coefficients in nnet layers represent the "brains" of the model, they are what is set during training
- training 
    - first iteration might be train via random data on internet (pre-training stage), output is often called base model
    - but better models will further train on hand picked and written data by humans (fine-tuning stage), output is assistant model
        - maybe 100k Q&A responses here, only takes maybe a day to train this
- large language model - generally all use large neural networks
    - words are fed into model, and output is next predicted word
- e.g. facebook open sourced llama-2-70b model (base model)
    - just 2 files: 140GB of parameter data (70bil params, each param 2B), 2nd file is 500 lines of c code
    - training took prolly 10TB of text data from internet, 60000 GPUs for 12 days ($2M, 1e24 FLOPS)
    - the parameters essentially encapsulate/represent the text, so in a way 140GB/10TB so 1/71 compression ratio
- modern (2024) - training rounds are 10x bigger than llama-2-70b, so training rounds cost 10-100mil dollars
- openAI chatgpt model architecture is closed source
- Tokens - a measure of the amount of data that can be remembered in a conversation, so limited context
    - input text is broken into smaller pieces, each called a token
### CLAUDE
- created by anthropic
### GEMINI
- created by google
### CHATGPT
- GPT3 - has 175B params/weights, organized into 28k matrices, ~50k words, ~12k embedding "dimenions", 2048 word context size
- model `gpt-4o-mini` - release 2024, free to use
### KHANMIGO
- openAI and sal khan(of khan academy) collaborated to create a AI tutor for kids
### DEEPSEEK
- jan'25 - came out and beat chatgpt's best model o1
- claims they spent on ly $6mil training it on 2000 nvidia H800s
### OLLAMA
- free LLM, can run it locally
### OTHER INFO
- tiktoken - open-source byte pair encoding (BPE) develeoped by OpenAPI to quickly encode text into tokens for input into LLMs
    - good for faster conversion into text tokens
    - token counting - determinte # of tokens in text tring (for API costs, LLMs have max token limits)
