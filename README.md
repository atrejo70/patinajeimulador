# 🛼 Downhill Skater Physics Simulator

[![Godot Engine](https://img.shields.io/badge/Godot_Engine-v4.3+-478cbf?logo=godotengine&logoColor=white)](https://godotengine.org)
[![Language](https://img.shields.io/badge/Language-GDScript-blue)](https://docs.godotengine.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Simulador interactivo 2D desarrollado en **Godot Engine 4** para analizar y visualizar la dinámica de movimiento de un patinador en una pendiente inclinada. El proyecto permite ajustar parámetros físicos clave (peso, inclinación, tamaño de ruedas, distancia y postura aerodinámica) observando sus efectos en tiempo real mediante un overlay de curvas de velocidad y aceleración.

---

## 📋 Tabla de Contenidos

- [Características Principales](#-características-principales)
- [Modelo Físico y Ecuaciones](#-modelo-físico-y-ecuaciones)
- [Jerarquía de Nodos del Proyecto](#-jerarquía-de-nodos-del-proyecto)
- [Estructura de Archivos](#-estructura-de-archivos)
- [Instalación y Configuración](#%EF%B8%8F-instalación-y-configuración)
- [Licencia](#-licencia)

---

## 🚀 Características Principales

* **Cálculo Realista de Fuerzas:** Modelado preciso de la gravedad en pendiente, la fricción de rodamiento y la resistencia del aire cuadrática.
* **Aerodinámica Dinámica:** Selección entre postura *Erguida (Upright)* y *Tuck (Aerodinámica)* que afecta el coeficiente de arrastre ($C_d$) y el área frontal ($A$).
* **Telemetría y Gráficas en Tiempo Real:** Panel de gráficas personalizado que dibuja simultáneamente las curvas de **Velocidad (Azul, km/h)** y **Aceleración (Rojo, m/s²)** contra el tiempo.
* **Panel UI Interactivo:** Sliders ajustables para masa ($\text{kg}$), pendiente ($\text{°}$), ruedas ($\text{mm}$) y distancia ($\text{m}$).
* **Código Modular:** Separación estricta entre la física del cuerpo (`RigidBody2D`), la lógica de la UI y el canvas de dibujo de gráficas.

---

## 📐 Modelo Físico y Ecuaciones

El movimiento se calcula dentro de `_physics_process()` aplicando la Segunda Ley de Newton ($F_{\text{neta}} = m \cdot a$):

$$F_{\text{neta}} = F_{\text{gravedad}} - F_{\text{rodamiento}} - F_{\text{aire}}$$

### 1. Fuerza Paralela a la Pendiente
$$F_{\text{gravedad}} = m \cdot g \cdot \sin(\theta)$$

### 2. Resistencia de Rodamiento
Inversamente proporcional al diámetro de las ruedas ($d_{\text{rueda}}$):
$$F_{\text{rodamiento}} = C_{rr} \cdot m \cdot g \cdot \cos(\theta) \quad \text{donde} \quad C_{rr} = \frac{0.002 \cdot 80}{d_{\text{rueda}}}$$

### 3. Resistencia del Aire (Arrastre Aerodinámico)
$$F_{\text{aire}} = \frac{1}{2} \cdot \rho \cdot C_d \cdot A \cdot v^2$$

Donde $\rho = 1.225 \, \text{kg/m}^3$ (densidad del aire) y los coeficientes cambian según la postura seleccionada:

| Postura | Coeficiente de Arrastre ($C_d$) | Área Frontal ($A$) | Impacto Físico |
| :--- | :---: | :---: | :--- |
| **Erguido (Upright)** | 0.90 | 0.55 m² | Mayor frenado aerodinámico; rápida saturación de velocidad máxima. |
| **Tuck (Aerodinámico)** | 0.50 | 0.30 m² | ~70% menos resistencia; alcanza velocidades terminales elevadas. |

---

## 🌳 Jerarquía de Nodos del Proyecto

El proyecto está estructurado de manera modular dividiendo la lógica física (`RigidBody2D`), la interfaz de usuario (`CanvasLayer`) y el sistema de renderizado de gráficas (`Control`).

### 1. Escena Principal (`res://Scenes/Main.tscn`)

```text
Main (Node2D) [Script: SimulationManager.gd]
├── Skater (Instancia: Skater.tscn)
└── UI (CanvasLayer)
    ├── Panel (Panel)
    │   └── VBoxContainer (VBoxContainer)
    │       ├── LblMass (Label)
    │       ├── SliderMass (HSlider)
    │       ├── LblSlope (Label)
    │       ├── SliderSlope (HSlider)
    │       ├── LblWheels (Label)
    │       ├── SliderWheels (HSlider)
    │       ├── LblDistance (Label)
    │       ├── SliderDistance (HSlider)
    │       ├── LblStance (Label)
    │       └── OptionStance (OptionButton)
    ├── Metrics (VBoxContainer)
    │   ├── LblSpeed (Label)
    │   ├── LblAccel (Label)
    │   └── LblDist (Label)
    ├── BtnStart (Button)
    ├── BtnReset (Button)
    └── GraphView (Instancia: GraphView.tscn)

### 2. Escena del Patinador (res://Scenes/Skater.tscn)
Plaintext

Skater (RigidBody2D) [Script: Skater.gd]
├── Sprite2D (Sprite2D / ColorRect)  --> Representación visual
└── CollisionShape2D (CollisionShape2D)  --> Forma de colisión (CapsuleShape2D)

    Nota de Configuración del RigidBody2D:

        Gravity Scale = 0 (La fuerza de gravedad en la pendiente se calcula vectorialmente por código).

        Lock Rotation = On (Evita rotaciones no deseadas durante el deslizamiento).

### 3. Escena del Panel de Gráficas (res://Scenes/GraphView.tscn)
Plaintext

GraphView (Control) [Script: GraphView.gd]

    Nota de Renderizado:
    El nodo GraphView utiliza el método virtual _draw() del nodo Control para procesar y redibujar en tiempo real las curvas mediante llamadas a draw_line().

## 📁 Estructura de Archivos
Plaintext

skater-physics-godot/
├── .gitignore
├── README.md
├── project.godot
├── Scenes/
│   ├── Main.tscn
│   ├── Skater.tscn
│   └── GraphView.tscn
└── Scripts/
    ├── Skater.gd
    ├── GraphView.gd
    └── SimulationManager.gd

## ⚙️ Instalación y Configuración

    Clona este repositorio en tu equipo:
    Bash

    git clone [https://github.com/TU_USUARIO/skater-physics-godot.git](https://github.com/TU_USUARIO/skater-physics-godot.git)

    Abre Godot Engine 4.x.

    Haz clic en Importar y selecciona el archivo project.godot dentro de la carpeta clonada.

    Presiona F5 (o el botón Play en la esquina superior derecha) para ejecutar la simulación.

## 📄 Licencia

Este proyecto está distribuido bajo la Licencia MIT. Consulta el archivo LICENSE para obtener más información.
