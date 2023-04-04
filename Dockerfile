FROM sebp/elk

# overwrite existing file
RUN rm /etc/logstash/conf.d/30-output.conf
COPY /logstash/conf/output.conf /etc/logstash/conf.d/30-output.conf

RUN rm /etc/logstash/conf.d/02-beats-input.conf
COPY /logstash/conf/input.conf /etc/logstash/conf.d/02-beats-input.conf


# docker build . --tag localls-elk
# docker run -p 5601:5601 -p 9200:9200 -p 5044:5044 -it --name elk local-elk