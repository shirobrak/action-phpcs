<?php

namespace TestSpace;

class Test
{
    /**
     * greet
     * @param    string  $name   display name
     */
    public function greet(string $name): void
    {
        print("Hello, " + $name);
    }
}
