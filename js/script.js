import * as THREE from 'three';
import { GLTFLoader } from 'three/addons/loaders/GLTFLoader.js';
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js';
import * as Tone from 'tone';

// Second shader testing
import portalVertexShaderSec from './shaderTest/second/vertex.glsl?raw';
import portalFragmentShaderSec from './shaderTest/second/fragment.glsl?raw';

const canvas = document.querySelector('canvas.webgl');
const scene = new THREE.Scene();

const size = {
    width: window.innerWidth,
    height: window.innerHeight
};

const camera = new THREE.PerspectiveCamera(45, size.width / size.height, 0.1, 100);
camera.position.x = 14;
camera.position.y = 15;
camera.position.z = 12;
scene.add(camera);

const controls = new OrbitControls(camera, canvas);
controls.enableDamping = true;

const renderer = new THREE.WebGLRenderer({
    canvas: canvas,
    antialias: true
});
renderer.setSize(size.width, size.height);
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));

const loader = new GLTFLoader();

const texture = new THREE.TextureLoader().load('assets/baked.jpg');
texture.flipY = -1;
const material = new THREE.MeshBasicMaterial({ map: texture });

const monitorPlanMaterialSec = new THREE.ShaderMaterial({
    uniforms: {
        iTime: { value: 0 },
        iResolution: { value: new THREE.Vector3(1920, 2500, 540) },
        iChannel0: { value: new THREE.Texture() },
    },
    vertexShader: portalVertexShaderSec,
    fragmentShader: portalFragmentShaderSec,
});

const lightSpeed = () => {
    // const osc = new Tone.Oscillator().toDestination();
    // // start at "C4"
    // osc.frequency.value = "C4";
    // // ramp to "C2" over 2 seconds
    // osc.frequency.rampTo("C2", 2);
    // // start the oscillator for 2 seconds
    // osc.start().stop("+3");

    const player = new Tone.Player("../assets/lightspeed.mp3").toDestination();
    Tone.loaded().then(() => {
        player.start();
    });
}

let counter = 1;

document.addEventListener('keyup', e => {
    if (e.code === 'ArrowDown' || e.code === 40) {
        counter++;
        loader.load(
            // resource URL
            'assets/room.glb',
            // called when the resource is loaded
            (gltf) => {
                console.log(gltf);
                gltf.scene.traverse(child => {
                    const blank = new THREE.MeshBasicMaterial();
                    if (child.name === "Cube") {
                        child.material = blank;
                        child.material = monitorPlanMaterialSec;
                        child.scale.x = counter;
                        child.scale.y = counter;
                        console.log(counter, child.scale.x, child.scale.y);
                    } else {
                        child.material = material;
                    }
                });
                gltf.scene.scale.setScalar(2);
                gltf.scene.rotation.y = -Math.PI / 2;
                scene.add(gltf.scene);
            }
        );
        lightSpeed();
    };
    if (e.code === 'ArrowUp' || e.code === 38) {
        lightSpeed();
    }
    if (e.code === 'Space' || e.code === 32) {
        loader.load(
            // resource URL
            'assets/room.glb',
            // called when the resource is loaded
            (gltf) => {
                gltf.scene.traverse(child => {
                    let color;
                    let materialRandom;
                    for (let i = 0; i < 18; i++) {
                        color = new THREE.Color(0xffffff);
                        color.setHex(Math.random() * 0xffffff);
                        materialRandom = new THREE.MeshBasicMaterial({ color });
                    };
                    // Changes all colors
                    // if (child) {
                    //     child.material = materialRandom;
                    // } else {
                    //     child.material = material;
                    // }
                    // Changes certain cubes colors
                    switch (child.name) {
                        case "Cube003":
                            child.material = materialRandom;
                            break;
                        case "Cube005":
                            child.material = materialRandom;
                            break;
                        case "Cube008":
                            child.material = materialRandom;
                            break;
                        case "Cube009":
                            child.material = materialRandom;
                            break;
                        default:
                            child.material = material;
                    }
                });
                gltf.scene.scale.setScalar(2);
                gltf.scene.rotation.y = -Math.PI / 2;
                scene.add(gltf.scene);
            }
        );
    };
});

const clock = new THREE.Clock();

const draw = () => {
    renderer.render(scene, camera);
    window.requestAnimationFrame(draw);
    const elapsedTime = clock.getElapsedTime();
    monitorPlanMaterialSec.uniforms.iTime.value = elapsedTime;
};

window.addEventListener('resize', () => {
    size.width = window.innerWidth;
    size.height = window.innerHeight;

    camera.aspect = size.width / size.height;
    camera.updateProjectionMatrix();

    renderer.setSize(size.width, size.height);
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
});

draw();