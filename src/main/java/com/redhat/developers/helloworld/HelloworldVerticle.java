/**
 * JBoss, Home of Professional Open Source
 * Copyright 2016, Red Hat, Inc. and/or its affiliates, and individual
 * contributors by the @authors tag. See the copyright.txt in the
 * distribution for a full listing of individual contributors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.redhat.developers.helloworld;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.text.StrSubstitutor;

import io.vertx.core.AbstractVerticle;
import io.vertx.core.http.HttpMethod;
import io.vertx.core.json.JsonArray;
import io.vertx.core.logging.Logger;
import io.vertx.core.logging.LoggerFactory;
import io.vertx.ext.asyncsql.AsyncSQLClient;
import io.vertx.ext.asyncsql.MySQLClient;
import io.vertx.ext.sql.ResultSet;
import io.vertx.ext.sql.SQLConnection;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.RoutingContext;
import io.vertx.ext.web.handler.CorsHandler;

public class HelloworldVerticle extends AbstractVerticle {

    public static final String version = "1.0";
    private Logger logger = LoggerFactory.getLogger(HelloworldVerticle.class);

    @Override
    public void start() throws Exception {
        Router router = Router.router(vertx);

        // Config CORS
        router.route().handler(CorsHandler.create("*")
            .allowedMethod(HttpMethod.GET)
            .allowedHeader("Content-Type"));

        // hello endpoint
        router.get("/api/hello/:name").handler(ctx -> {
            String helloMsg = hello(ctx.request().getParam("name"));
            logger.info("New request from " + ctx.request().getHeader("User-Agent") + "\nSaying...: " + helloMsg);
            ctx.response().end(helloMsg);
        });

        // Database endpoint
        router.get("/api/db").handler(ctx -> {
            logger.info("Reading records from the database");
            readFromDatabase(ctx);
        });

        // hello endpoint
        router.get("/api/hello/:name").handler(ctx -> {
            String helloMsg = hello(ctx.request().getParam("name"));
            logger.info("New request from " + ctx.request().getHeader("User-Agent") +
                "\nSaying...: " + helloMsg);
            ctx.response().end(helloMsg);
        });

        // health check endpoint
        router.get("/api/health").handler(ctx -> {
            ctx.response().end("I'm ok");
        });
        vertx.createHttpServer().requestHandler(router::accept).listen(8080);
    }

    private void readFromDatabase(RoutingContext ctx) {
        AsyncSQLClient mySQLClient = MySQLClient.createNonShared(vertx, ApplicationConfiguration.load(config()));
        mySQLClient.getConnection(res -> {
            if (res.succeeded()) {
                SQLConnection connection = res.result();
                connection.query("SELECT name FROM mytable", q -> {
                    if (q.succeeded()) {
                        // Get the result set
                        ResultSet resultSet = q.result();
                        List<JsonArray> results = resultSet.getResults();
                        ctx.response().end(results.toString());
                    } else {
                        q.cause().printStackTrace();
                        ctx.response().end("Error executing the query. Check the logs");
                    }
                });
            } else {
                res.cause().printStackTrace();
                ctx.response().end("No connection to the database.");
            }
        });
    }

    private String hello(String name) {
        String configGreeting = ApplicationConfiguration.load(config()).getString("GREETING");
        String greeting = configGreeting == null ? "Hello {name} from {hostname} with {version}" : configGreeting;
        Map<String, String> values = new HashMap<String, String>();
        values.put("name", name);
        values.put("hostname", System.getenv().getOrDefault("HOSTNAME", "unknown"));
        values.put("version", version);
        return new StrSubstitutor(values, "{", "}").replace(greeting);
    }

}
