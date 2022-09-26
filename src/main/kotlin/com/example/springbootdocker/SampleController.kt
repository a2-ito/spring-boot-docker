package com.example.springbootdocker

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

import org.springframework.beans.factory.annotation.Value

@RestController
class SampleController {
    @Value("\${sample.foo}")
    val stringParam = ""
    @GetMapping("/")
    fun getHello() :String {
      println("stringParam=$stringParam")
      return "Hello World"
    }
}

class ValueComponent {
  @Value("\${sample.foo}")
  val stringParam = ""

  fun main() {
    println("stringParam=$stringParam")
  }
}
