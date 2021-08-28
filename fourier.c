#include <stdio.h>
#include <stdlib.h>
#include <math.h>		/* Declares sin(), cos(), etc. */

/*
 * To compile:
 *	cc -o _fourier  _fourier.c -lm
 */

struct point {
    double x, y;
};

void fatal(char *msg)
{
  fprintf(stderr, "_fourier: %s\n", msg);
  exit(1);
}

int main(int argc, char *argv[])
{
  int n;							/* width and height of image */
  double srange;						/* width/2 and height/2 of fourier space */
  double scale;							/* scaling applied to magnitude */
  int w, i, j, k;
  struct point s;
  struct point *source;
  double re, im, *coeff;
  int nsource;
  double dot, mag;
  int imag;

  /*
   * Read parameters.
   */
  if (argc != 1)
    fatal("wrong number of arguments");
  if (3 != scanf("%d %lf %d\n", &n, &srange, &nsource))
    fatal("incomplete parameter line");
  if (n <= 0)
    fatal("size of image must be greater than 0");
  if (srange <= 0)
    fatal("range of fourier space must be greater than 0");

  /*
   * Allocate and read light sources.
   */
  source = (struct point *)malloc(nsource * sizeof(struct point));
  for (i = 0; i < nsource; i += 1)
    if (2 != scanf("%lf %lf\n", &source[i].x, &source[i].y))
      fatal("bad point line");

  /*
   * Pre compute coefficients
   */
  coeff = calloc(n, sizeof(double));
  for (i = 0; i < n; i += 1)
    coeff[i] = 2 * M_PI * srange * ((float)i/(n-1) - .5);

  scale = nsource > 0 ? 1.0 / nsource : 1;

  /*
   * Compute transform by blocks, starting from a block that sets the
   * entire image to the value of the 0,0 pixel, then computing the
   * other three quadrants of the image, and continuing by computing
   * subquadrants until the individual pixels are done.
   */
  for (w = n; w >= 1; w /= 2) {
    int wt2 = 2*w;
    for (i = 0; i < n; i += w) {
      s.y = coeff[i];
      for (j = 0; j < n; j += w) {
	if ((i%wt2) != 0 || (j%wt2) != 0 || w == n) {
	  s.x = coeff[j];
	  re = im = 0;
	  for(k = 0; k < nsource; k++) {
	    dot = s.x*source[k].x + s.y*source[k].y;
	    re += cos(dot);
	    im += sin(dot);
	  }
	  mag = scale * sqrt(re*re + im*im);
	  /*
	   * Report the current estimate for the magnitude in the rectangle
	   * from j i to j+w i+w, namely the magnitude at j i.
	   */
	  printf("%f %d %d %d %d\n", mag, j, i, j+w, i+w);
	  fflush(stdout);
	}
      }
    }
  }
  exit(0);
}


