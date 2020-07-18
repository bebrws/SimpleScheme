# Quick test for drawing a line

Used NodeJS:

        for (let i =0; i<200; i++) { console.log(`(set-pixel ${i} ${i} 100 100 50 100)`) }
        
Scheme Output:

        (display "Drawing a line with recursion")

        (define (func x y) 
            (display x) 
            (set-pixel x x 100 0 100 100) 
            (display "\n")  
            (if (eq? x 100) 
                (+ x 1) 
                (func (+ x 1) y)  
            )  
        )

        (display "Starting the function:")
        (func 0 0)
