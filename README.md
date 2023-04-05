# elk-sleuth-springboot
``
# How to start the application ?

cd elk-sleuth-springboot
cd modules
cd service-registry
mvn clean install
mvn spring-boot:run

cd modules
cd cloud-config-server
mvn clean install
mvn spring-boot:run

cd modules
cd cloud-config-server
mvn clean install
mvn spring-boot:run

cd modules
cd payment-service
mvn clean install
mvn spring-boot:run

cd modules
cd order-service
mvn clean install
mvn spring-boot:run


All the components are started now. We need to build docker image now, and start it. Use Dockerfile in root folder.

Docker ELK :
https://elk-docker.readthedocs.io/
docker build . --tag local-elk
docker run -p 5601:5601 -p 9200:9200 -p 5044:5044 -it --name elk local-elk

To start zipkin server:
https://zipkin.io/pages/quickstart
docker run -d -p 9411:9411 openzipkin/zipkin

Zipkin tracing dashboard :
http://localhost:9411/zipkin/


Kibana logs :
http://localhost:5601/

ElasticSearch : 
http://localhost:9200/

Eureka Client :
http://localhost:8761/




# Call services using Postman :
-----------
```bash
URL : http://localhost:9192/order/bookOrder
HTTP Method : POST
```
Json Request :
```json
{
	"order":{
		"id":103,
		"name":"Mobile",
		"qty":1,
		"price":8000
		
	},
	"payment":{}
}
```
Json Response :
```json
{
    "order": {
        "id": 26,
        "name": "ear-phone",
        "qty": 5,
        "price": 4000
    },
    "amount": 4000,
    "transactionId": "9a021fa6-2061-4332-bdb7-b1358b3430c2",
    "message": "payment processing successful and order placed"
}

```
```bash
URL : http://localhost:8989/payment/26
HTTP Method : GET
```
Json Response :
```json
{
    "paymentId": 1,
    "transactionId": "d86cfeca-0b26-455e-a1a2-ac3e53707829",
    "orderId": 103,
    "paymentStatus": "SUCCESS",
    "amount":4000
}
```



logstash plugin for input/output configuration :
https://www.elastic.co/guide/en/logstash/current/plugins-inputs-tcp.html

# getting error while running ? Check below : 
# Kibana logs not showing ?
There could be an error while running the elk container image. So check the logs when you run
this container image.
Logstash unable to start was a problem for me, because of the property ssl=>true initially set
in logstash/input.conf file

# logstash problem ?
https://discuss.elastic.co/t/logstash-an-exceptioncaught-event-was-fired-and-it-reached-at-the-tail-of-the-pipeline-it-usually-means-the-last-handler-in-the-pipeline-did-not-handle-the-exception/180515



-------------

# For my local purpose : 
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
https://stackoverflow.com/questions/62017152/not-able-to-change-the-jdk-in-mac-os-using-jenv

# Where does elasticsearch store data ?
https://stackoverflow.com/questions/33303786/where-does-elasticsearch-store-its-data
Elasticsearch does not store all data on the heap. Instead data is read from disk when 
required and the heap is basically used as working memory. This is why the heap should be as 
most 50% of available RAM (ideally as small as the use case allows 4). The rest of available RAM is 
used for some off-heap storage 
and the operating system page cache, which are both essential for good performance.



# Helpful Links
To start zipkin as a spring boot server application :
https://www.tutorialspoint.com/spring_boot/spring_boot_tracing_micro_service_logs.htm#:~:text=Zipkin%20is%20an%20application%20that,in%20our%20build%20configuration%20file.

Zipkin is not a logging tool. It is a span tool It can tell you about the latency issues in a distributed system.
https://stackoverflow.com/questions/54555618/send-only-info-level-logs-to-zipkin

Tutorial ELK SLeuth:
https://www.tutorialspoint.com/spring_cloud/spring_cloud_distributed_logging_using_elk_and_sleuth.htm
https://medium.com/swlh/distributed-tracing-in-micoservices-using-spring-zipkin-sleuth-and-elk-stack-5665c5fbecf

docker run -d -it --name logstash -p 5000:5000 logstash -e 'input { tcp { port => 5000 codec => "json" } } output { elasticsearch { hosts => ["192.168.99.100"] index => "micro-%{serviceName}"} }'
