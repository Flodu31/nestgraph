# nestgraph
This Dockerfile will give you the possibility to show your nest values in a graph, from a webpage:
![Graph of values](https://raw.githubusercontent.com/Flodu31/nestgraph/master/NestGraph.png)
# Instruction
To use this Dockerfile, use the following commands:

```
cd {Your_Folder}
git clone https://github.com/Flodu31/nestgraph.git
docker build -t nestgraph .
docker run -d -P -e ENV_NEST_USER='your_nest_email_address' -e ENV_NEST_PASSWORD='your_nest_password' --name nestgraph nestgraph
```

## Source
nestgraph: https://github.com/chriseng/nestgraph

nest-api: https://github.com/gboudreau/nest-api
