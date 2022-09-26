package com.example.springbootdocker

import org.apache.catalina.connector.Connector
import org.apache.coyote.http11.Http11NioProtocol
import org.apache.tomcat.util.net.SSLHostConfig
import org.apache.tomcat.util.net.SSLHostConfigCertificate
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.web.embedded.tomcat.TomcatServletWebServerFactory
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import java.security.KeyStore


@Configuration
open class TomcatConfiguration {

    @Autowired
    var keyStore: KeyStore? = null

    @Bean
    open fun containerFactory(): TomcatServletWebServerFactory {
        return object : TomcatServletWebServerFactory() {
            override fun customizeConnector(connector: Connector) {
                super.customizeConnector(connector);
                connector.scheme = "https"
                connector.secure = true

                val protocol = connector.protocolHandler as Http11NioProtocol
                //protocol.setSSLProtocol("TLSv1,TLSv1.1,TLSv1.2")
                //protocol.isSSLEnabled = true

                val originMaxKeepAliveRequests = protocol.getMaxKeepAliveRequests()
                val paramKeepAliveTimeout = protocol.getKeepAliveTimeout()
                val originMaxThreads = protocol.getMaxThreads()
                val originConnectionTimeout = protocol.getConnectionTimeout()
                val originPort = protocol.getPort()
                val originMaxConnections = protocol.getMaxConnections()
                println("oritin MaxKeepAliveRequests  = $originMaxKeepAliveRequests")
                println("oritin KeepAliveTimeout      = $paramKeepAliveTimeout")
                println("origin MaxThreads            = $originMaxThreads")
                println("origin ConnectionTimeout     = $originConnectionTimeout")
                println("origin Port                  = $originPort")
                println("origin MaxConnections        = $originMaxConnections")

                protocol.setMaxKeepAliveRequests(0)
                val afterMaxKeepAliveRequests = protocol.getMaxKeepAliveRequests()
                println("MaxKeepAliveRequests         = $afterMaxKeepAliveRequests")

                protocol.setKeepAliveTimeout(0)
                val afterKeepAliveTimeout = protocol.getKeepAliveTimeout()
                println("KeepAliveTimeout             = $afterKeepAliveTimeout")

            }
        };

    }

}


