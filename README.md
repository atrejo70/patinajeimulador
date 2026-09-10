# 🛼 Downhill Skater Physics Simulator (Godot 4)

Simulador interactivo 2D desarrollado en **Godot Engine 4** para estudiar la dinámica de deslizamiento de un patinador en una pendiente inclinada.

## 🚀 Características
- **Cálculo de Fuerzas Dinámicas:**
  - Componente de gravedad en pendiente ($F = m \cdot g \cdot \sin\theta$).
  - Resistencia de rodamiento inversamente proporcional al tamaño de rueda ($58\text{mm} - 110\text{mm}$).
  - Resistencia del aire cuadrática basada en la postura del patinador (**Erguido** vs. **Tuck**).
- **Telemetría y Gráficas en Tiempo Real:**
  - Visualización dual overlay: Velocidad (Azul, km/h) y Aceleración (Rojo, m/s²).
  - Medidores dinámicos de posición y tiempo transcurrido.
- **Interfaz Configurable:** Sliders interactivos y controles modulares.

## 📐 Ecuaciones Utilizadas
$$F_{\text{neta}} = m \cdot g \cdot \sin(\theta) - C_{rr} \cdot m \cdot g \cdot \cos(\theta) - \frac{1}{2} \rho C_d A v^2$$

Donde:
- $C_{rr} \approx \frac{0.16}{d_{\text{rueda}}}$
- Postura Erguida: $C_d = 0.9, A = 0.55\text{ m}^2$
- Postura Tuck: $C_d = 0.5, A = 0.30\text{ m}^2$

## 📦 Requisitos e Instalación
1. Descarga o clona este repositorio:
   ```bash
   git clone [https://github.com/TU_USUARIO/skater-physics-godot.git](https://github.com/TU_USUARIO/skater-physics-godot.git)
