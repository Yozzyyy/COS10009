# Acknowledgement to the original authors of the code on which this 
# example is based.
import pygame

pygame.init()

SCREEN_HEIGHT = 400
SCREEN_WIDTH = 400

screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT)) #screen size
done = False
is_blue = True
x = 30
y = 30

time = pygame.time #using python time
clock = pygame.time.Clock()

while not done: #!false
        clock.tick(60)
        for event in pygame.event.get():
               
                if event.type == pygame.QUIT: #quit if true
                        done = True 
                if event.type == pygame.KEYDOWN and event.key == pygame.K_SPACE: #space changes the color
                        is_blue = not is_blue 
        
        pressed = pygame.key.get_pressed()

       
        if pressed[pygame.K_LEFT] and x >= 0: x -= 3 #left key decrement by 3
        if pressed[pygame.K_RIGHT] and x <= SCREEN_WIDTH - 60: x += 3 #right key increment by 3
        if pressed[pygame.K_UP] and y >= 0: y -= 3 #up key decrement upwards
        if pressed[pygame.K_DOWN] and y <= SCREEN_HEIGHT - 60: y += 3 # down key increment y value downwards

        print(f"x is {x} y is {y} timer is {time.get_ticks()}") #x cord and y cords included times ticks

        screen.fill((0, 0, 0)) #total screen filling 
        if is_blue: color = (0, 128, 255) #using blue color
        else: color = (255, 100, 0) #when space cahnged color

        rect = pygame.Rect(x, y, 60, 60) #
        pygame.draw.rect(screen, color, rect) #draw rectagle

        pygame.display.flip()
