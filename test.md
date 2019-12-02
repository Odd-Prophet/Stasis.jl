+++
title = "Scaled Conjugate Gradient"
slug = "scaled-conjugate-gradient"
category = "Lesson"
date = "11-29-2019"
excerpt = "The scaled conjugate gradient is a powerful optimization algorithm for training neural networks..."
+++

The scaled conjugate gradient is a powerful optimization algorithm for training neural networks. Martin Møller published this method in 1997 as a part of his Ph.D. research [1]. It trains networks way faster (10x+) than the most popular optimizers, stochastic gradient descent and adaptive moment estimation.

Classical optimizers take steps down a gradient according to a learning rate. Scaled conjugate gradient eschews the learning rate and jumps to the apporiximate minimum in that direction directly.

How does it work?

First we'll start with the conjugate gradient method.

Taylor series:

```math
f(x + {\Delta}x) = \sum\limits_{n=0}^{\infty} \frac{f^{(n)}(x) \Delta x^n}{n!}
```

Truncate it to approximate:

```math
\hat{f}(x + {\Delta}x) \approx f(x) + f'(x) \Delta x + \frac{1}{2} f''(x) \Delta x^2
```

We want to know what value of `` \Delta x `` minimizes `` \hat{f}(x + {\Delta}x) ``

Take derivative, set to 0, solve for `` \Delta x ``:

```math
\begin{aligned}
\frac{d\hat{f}(x + \Delta x)}{d \Delta x} &= f'(x) + f''(x) \Delta x \\[2ex]
0 &= f'(x) + f''(x) \Delta x \\[2ex]
\Delta x &= - \frac{f'(x)}{f''(x)}
\end{aligned}
```

This is has all been for a function `` f(x) `` for a single scalar variable `` x ``.

When applied to neural networks, we want to minimize a loss function over all the weights of the network. When collected into a vector `` w ``, the first derivative is written as the gradient:

```math
{\nabla_w} f = (\frac{\partial f}{\partial w_1},\ \frac{\partial f}{\partial w_2},\ \dots \ ,\ \frac{\partial f}{\partial w_n})
```

The second derivative then is the matrix `` \frac{\partial^2 f}{\partial w_i \partial w_j} `` written as the hessian:


```math
\nabla^2_w f =
\begin{pmatrix}
a & b \\
c & d 
\end{pmatrix}
```

[1]: http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.50.8063&rep=rep1&type=pdf