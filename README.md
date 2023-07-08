# AutoGPTSwift
 
This is a very simple re-implementation of [AutoGPT](https://github.com/Significant-Gravitas/Auto-GPT) or [LangChain](https://github.com/hwchase17/langchain) in Swift. In essence, it is an LLM (GPT-3.5) powered chat application that is able to use tools (Google search and a calculator) in order to hold conversations and answer questions. 

Here's an example:

~~~
Q: What is the world record for solving a rubiks cube?
The world record for solving a Rubik's Cube is 4.69 seconds, held by Yiheng Wang (China).
Q: Can a robot solve it faster?
The fastest time a robot has solved a Rubik's Cube is 0.637 seconds.
Q: Who made this robot?
Infineon created the robot that solved a Rubik's Cube in 0.637 seconds.
Q: What time would an average human expect for solving?
It takes the average person about three hours to solve a Rubik's cube for the first time.
~~~

This is not intended to be a replacement for LangChain, instead it was built for fun and educational purposes. If you're interested in how LangChain, and similar tools work, this is a good starting point.
