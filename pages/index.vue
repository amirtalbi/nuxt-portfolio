<template>
  <div class="w-full min-h-screen">
    <section
      class="min-h-screen px-8 md:px-12 flex flex-col justify-center gap-6 md:gap-12 lg:gap-16 2xl:gap-32 container mx-auto"
    >
      <div>
        <div class="flex flex-col items-center text-center gap-4">
          <h3
            class="text-2xl sm:text-3xl md:text-4xl 2xl:text-2xl font-medium text-gray-300 animate-fade-in"
          >
            Bonjour, je suis Amir !
          </h3>
          <h2
            class="text-5xl sm:text-7xl md:text-8xl xl:text-9xl 2xl:text-9xl font-bold animate-fade-in"
          >
            Développeur
          </h2>
          <h2
            class="text-6xl sm:text-8xl md:text-9xl xl:text-[10rem] 2xl:text-[11rem] font-bold flex flex-wrap justify-center gap-2 animate-fade-in"
          >
            <span class="mr-2 md:mr-8 text-primary italic">full</span>stack
          </h2>
        </div>
      </div>
      <div
        class="flex flex-col items-center text-center lg:flex-row-reverse lg:items-center lg:justify-between space-between gap-14"
      >
        <div class="flex flex-col items-center gap-4 animate-fade-in">
          <div class="flex gap-4">
            <NuxtLink
              to="https://www.linkedin.com/in/amirtalbi"
              target="_blank"
              external
              class="flex gap-2 items-center justify-center min-h-10 min-w-10 2xl:min-h-14 2xl:min-w-14 rounded-full border-2 border-gray-500 hover:border-primary transition duration-300"
            >
              <Icon
                name="fa:linkedin"
                class="text-gray-300 text-lg 2xl:text-2xl"
              />
            </NuxtLink>

            <NuxtLink
              to="https://github.com/amirtalbi"
              target="_blank"
              external
              class="flex gap-2 items-center justify-center min-h-10 min-w-10 2xl:min-h-14 2xl:min-w-14 rounded-full border-2 border-gray-500 hover:border-primary transition duration-300"
            >
              <Icon
                name="fa:github"
                class="text-gray-300 text-lg 2xl:text-2xl"
              />
            </NuxtLink>

            <NuxtLink
              to="mailto:amir.talbi@example.com"
              class="flex gap-2 items-center justify-center min-h-10 min-w-10 2xl:min-h-14 2xl:min-w-14 rounded-full border-2 border-gray-500 hover:border-primary transition duration-300"
            >
              <Icon
                name="fa:envelope"
                class="text-gray-300 text-lg 2xl:text-2xl"
              />
            </NuxtLink>

            <button
              @click="openCvModal"
              class="flex gap-2 items-center justify-center min-h-10 min-w-10 2xl:min-h-14 2xl:min-w-14 rounded-full border-2 border-gray-500 hover:border-primary transition duration-300 cursor-pointer"
            >
              <span
                class="uppercase font-semibold text-sm xl:text-md 2xl:text-xl text-gray-300"
                >CV</span
              >
            </button>
          </div>

          <div class="flex flex-col gap-2">
            <a
              href="#projects"
              class="flex gap-2 items-center justify-center px-4 2xl:px-6 min-h-10 min-w-10 2xl:min-h-14 2xl:min-w-14 rounded-full border-2 border-gray-500 hover:border-primary transition duration-300"
            >
              <span
                class="uppercase font-semibold text-sm xl:text-md 2xl:text-xl text-gray-300"
              >
                mes projets
              </span>
              <Icon
                name="fa:angle-down"
                class="text-gray-300 text-lg 2xl:text-2xl"
              />
            </a>

            <a
              href="#skills"
              class="flex gap-2 items-center justify-center px-4 2xl:px-6 min-h-10 min-w-10 2xl:min-h-14 2xl:min-w-14 rounded-full border-2 border-gray-500 hover:border-primary transition duration-300"
            >
              <span
                class="uppercase font-semibold text-sm xl:text-md 2xl:text-xl text-gray-300"
              >
                mes compétences
              </span>
              <Icon
                name="fa:angle-down"
                class="text-gray-300 text-lg 2xl:text-2xl"
              />
            </a>
          </div>
        </div>
      </div>
    </section>

    <section
      class="min-h-screen w-full md:w-5/6 px-4 sm:px-8 md:px-12 flex flex-col justify-center gap-6 md:gap-12 lg:gap-16 2xl:gap-32 container mx-auto pb-12"
    >
      <div>
        <h1
          id="projects"
          class="text-xl sm:text-2xl md:text-3xl 2xl:text-5xl font-medium text-gray-300 mb-8 2xl:mb-16 animate-fade-in"
        >
          Mes projets
        </h1>

        <div class="grid gap-8 md:gap-12">
          <UCard
            v-for="(project, index) in projects"
            :key="index"
            class="w-full bg-gray-800/50 border border-gray-700/50 rounded-2xl shadow-2xl backdrop-blur-sm hover:shadow-primary/10 hover:border-primary/30 transition-all duration-300 overflow-hidden group"
          >
            <div class="p-4 sm:p-6 md:p-8">
              <div
                class="flex flex-col gap-6 sm:gap-8 lg:flex-row lg:gap-8 items-start"
              >
                <!-- Image placeholder ou vraie image -->
                <div class="flex-shrink-0 w-full max-w-full lg:w-80 xl:w-96">
                  <div
                    v-if="!project.image"
                    class="w-full h-48 sm:h-64 md:h-80 bg-gradient-to-br from-primary/20 to-orange-500/20 rounded-xl flex items-center justify-center"
                  >
                    <Icon
                      name="fa:code"
                      class="text-5xl sm:text-6xl text-gray-400"
                    />
                  </div>
                  <img
                    v-else
                    :src="project.image"
                    :alt="project.name"
                    class="w-full h-48 sm:h-64 md:h-80 object-cover rounded-xl shadow-lg"
                    loading="lazy"
                  />
                </div>

                <!-- Contenu -->
                <div
                  class="flex-1 max-w-full xl:max-w-2xl space-y-3 sm:space-y-4"
                >
                  <div class="space-y-1 sm:space-y-2">
                    <div
                      class="flex flex-wrap items-center gap-2 sm:gap-3 mb-2"
                    >
                      <h2
                        class="text-xl sm:text-2xl md:text-3xl font-bold text-white group-hover:text-primary transition-colors duration-300 break-words"
                      >
                        {{ project.name }}
                      </h2>
                      <!-- Statut du projet -->
                      <span
                        :class="
                          project.finished
                            ? 'bg-green-500/10 text-green-400 border-green-500/20'
                            : 'bg-yellow-500/10 text-yellow-400 border-yellow-500/20'
                        "
                        class="px-2 py-1 text-xs font-medium rounded-full border whitespace-nowrap"
                      >
                        {{ project.finished ? "Terminé" : "En cours" }}
                      </span>
                    </div>
                    <h3
                      class="text-base sm:text-lg md:text-xl text-primary font-medium break-words"
                    >
                      {{ project.title }}
                    </h3>
                  </div>

                  <p
                    class="text-gray-300 leading-relaxed text-sm sm:text-base md:text-lg break-words"
                  >
                    {{ project.description }}
                  </p>

                  <!-- Technologies -->
                  <div class="flex flex-wrap gap-2 pt-2 sm:pt-4">
                    <span
                      v-for="tech in project.technologies"
                      :key="tech"
                      class="px-2 py-1 sm:px-3 sm:py-1 bg-primary/10 text-primary border border-primary/20 rounded-full text-xs sm:text-sm font-medium"
                    >
                      {{ tech }}
                    </span>
                  </div>

                  <!-- Link (si disponible) -->
                  <div v-if="project.link" class="pt-2 sm:pt-4">
                    <NuxtLink
                      :to="project.link"
                      target="_blank"
                      class="inline-flex items-center gap-2 px-4 sm:px-6 py-2 sm:py-3 bg-primary hover:bg-primary/80 text-white font-medium rounded-lg transition-all duration-300 hover:shadow-lg hover:shadow-primary/25 w-full sm:w-auto text-center justify-center"
                    >
                      Voir le projet
                      <Icon name="fa:external-link" class="text-sm" />
                    </NuxtLink>
                  </div>
                </div>
              </div>
            </div>
          </UCard>
        </div>
      </div>
    </section>

    <section
      id="skills"
      class="min-h-screen px-8 md:px-12 flex flex-col justify-center gap-6 md:gap-12 lg:gap-16 2xl:gap-32 container mx-auto"
    >
      <div>
        <h1
          class="text-xl sm:text-2xl md:text-3xl 2xl:text-5xl font-medium text-gray-300 mb-8 2xl:mb-16 animate-fade-in"
        >
          Mes compétences
        </h1>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-12">
          <UCard
            v-for="(skillCategory, index) in skills"
            :key="index"
            class="bg-gray-800/50 border border-gray-700/50 rounded-xl shadow-xl backdrop-blur-sm hover:shadow-primary/10 hover:border-primary/30 transition-all duration-300 overflow-hidden group"
          >
            <div class="p-6">
              <!-- Header avec icône et titre -->
              <div class="flex items-center gap-4 mb-6">
                <div
                  :class="`bg-gradient-to-r ${skillCategory.color}`"
                  class="w-12 h-12 rounded-lg flex items-center justify-center shadow-lg"
                >
                  <Icon :name="skillCategory.icon" class="text-white text-xl" />
                </div>
                <h3
                  class="text-xl font-bold text-white group-hover:text-primary transition-colors duration-300"
                >
                  {{ skillCategory.category }}
                </h3>
              </div>

              <!-- Liste des compétences -->
              <div class="flex flex-wrap gap-2">
                <span
                  v-for="skill in skillCategory.skills"
                  :key="skill"
                  class="px-3 py-1.5 bg-gray-700/50 text-gray-300 border border-gray-600/50 rounded-lg text-sm font-medium hover:bg-primary/10 hover:text-primary hover:border-primary/20 transition-all duration-200"
                >
                  {{ skill }}
                </span>
              </div>
            </div>
          </UCard>
        </div>
      </div>
    </section>



    <!-- Footer -->
    <footer
      class="py-8 px-8 md:px-12 border-t border-gray-700/50 bg-gray-900/50"
    >
      <div
        class="container flex flex-col md:flex-row items-center justify-between gap-6 mx-auto"
      >
        <p class="text-gray-400 text-sm md:text-base">
          Made with <span class="text-red-500 animate-pulse">❤️</span> by
          <NuxtLink
            to="https://webinnov-paris.fr/"
            target="_blank"
            external
            class="text-primary hover:text-primary/80 font-medium transition-colors duration-300"
          >
            Webinnov Paris
          </NuxtLink>
          aka
          <span class="text-white font-medium">Amir Talbi</span>
        </p>
        <div class="flex gap-4">
          <NuxtLink
            to="https://www.linkedin.com/in/amirtalbi"
            target="_blank"
            external
            class="flex gap-2 items-center justify-center min-h-10 min-w-10 2xl:min-h-14 2xl:min-w-14 rounded-full border-2 border-gray-500 hover:border-primary transition duration-300"
          >
            <Icon
              name="fa:linkedin"
              class="text-gray-300 text-lg 2xl:text-2xl"
            />
          </NuxtLink>

          <NuxtLink
            to="https://github.com/amirtalbi"
            target="_blank"
            external
            class="flex gap-2 items-center justify-center min-h-10 min-w-10 2xl:min-h-14 2xl:min-w-14 rounded-full border-2 border-gray-500 hover:border-primary transition duration-300"
          >
            <Icon name="fa:github" class="text-gray-300 text-lg 2xl:text-2xl" />
          </NuxtLink>

          <NuxtLink
            to="mailto:amir.talbi@example.com"
            class="flex gap-2 items-center justify-center min-h-10 min-w-10 2xl:min-h-14 2xl:min-w-14 rounded-full border-2 border-gray-500 hover:border-primary transition duration-300"
          >
            <Icon
              name="fa:envelope"
              class="text-gray-300 text-lg 2xl:text-2xl"
            />
          </NuxtLink>

          <button
            @click="openCvModal"
            class="flex gap-2 items-center justify-center min-h-10 min-w-10 2xl:min-h-14 2xl:min-w-14 rounded-full border-2 border-gray-500 hover:border-primary transition duration-300 cursor-pointer"
          >
            <span
              class="uppercase font-semibold text-sm xl:text-md 2xl:text-xl text-gray-300"
              >CV</span
            >
          </button>
        </div>
      </div>
    </footer>

    <!-- Modale CV Custom -->
    <Teleport to="body" v-if="showCvModal">
      <div
        class="fixed inset-0 z-50 flex items-center justify-center bg-black/80 backdrop-blur-sm p-4"
        @click="closeCvModal"
      >
        <div
          class="bg-gray-900 rounded-2xl overflow-hidden max-w-6xl w-full max-h-[95vh] md:max-h-[90vh] overflow-y-auto"
          @click.stop
        >
          <!-- Header de la modale -->
          <div
            class="flex items-center justify-between p-4 md:p-6 border-b border-gray-700"
          >
            <div class="flex items-center gap-3">
              <div
                class="w-8 h-8 md:w-10 md:h-10 bg-gradient-to-r from-primary to-orange-500 rounded-lg flex items-center justify-center"
              >
                <Icon
                  name="fa:file-pdf-o"
                  class="text-white text-sm md:text-lg"
                />
              </div>
              <div>
                <h3 class="text-lg md:text-xl font-bold text-white">
                  Curriculum Vitae
                </h3>
                <p class="text-xs md:text-sm text-gray-400">
                  Amir Talbi - Développeur Full Stack
                </p>
              </div>
            </div>
            <button
              @click="closeCvModal"
              class="w-8 h-8 rounded-full bg-gray-800 hover:bg-gray-700 flex items-center justify-center transition-colors duration-200 cursor-pointer"
            >
              <Icon name="fa:times" class="text-gray-400 hover:text-white" />
            </button>
          </div>

          <!-- Contenu de la modale -->
          <div class="p-4 md:p-6">
            <!-- Aperçu du CV ou fallback mobile -->
            <div
              v-if="isMobile"
              class="bg-gray-800/50 rounded-xl p-4 mb-4 md:mb-6 flex flex-col items-center justify-center"
            >
              <Icon name="fa:file-pdf-o" class="text-4xl text-red-500 mb-2" />
              <p class="text-base font-medium mb-2 text-center">
                Aperçu du CV non supporté sur mobile.
              </p>
              <a
                href="/amir-talbi-cv.pdf"
                target="_blank"
                class="px-4 py-2 bg-primary hover:bg-primary/80 text-white rounded-lg font-medium transition-all duration-200 hover:shadow-lg hover:shadow-primary/25 cursor-pointer flex items-center justify-center gap-2 text-sm md:text-base mb-2"
              >
                <Icon name="fa:external-link" />
                Ouvrir dans un nouvel onglet
              </a>
              <a
                href="/amir-talbi-cv.pdf"
                download
                class="px-4 py-2 bg-blue-600 hover:bg-blue-500 text-white rounded-lg font-medium transition-all duration-200 cursor-pointer flex items-center justify-center gap-2 text-sm md:text-base"
              >
                <Icon name="fa:download" />
                Télécharger
              </a>
            </div>
            <div
              v-else
              class="bg-gray-800/50 rounded-xl p-2 md:p-4 mb-4 md:mb-6"
            >
              <div
                class="aspect-[210/297] bg-white rounded-lg overflow-hidden relative"
              >
                <!-- Affichage du PDF directement dans un iframe -->
                <iframe
                  src="/amir-talbi-cv.pdf#toolbar=0&navpanes=0&scrollbar=0"
                  class="w-full h-full rounded-lg"
                  title="Aperçu du CV de Amir Talbi"
                  @error="handleIframeError"
                >
                </iframe>
                <!-- Fallback si le PDF ne se charge pas -->
                <div
                  v-if="iframeError"
                  class="absolute inset-0 flex items-center justify-center bg-white rounded-lg"
                >
                  <div class="text-center text-gray-600 p-4">
                    <Icon
                      name="fa:file-pdf-o"
                      class="text-4xl md:text-6xl mb-2 md:mb-4 text-red-500"
                    />
                    <p class="text-base md:text-lg font-medium">Aperçu du CV</p>
                    <p class="text-xs md:text-sm">amir-talbi-cv.pdf</p>
                    <p class="text-xs mt-2 text-gray-500">
                      Utilisez les boutons ci-dessous pour télécharger ou ouvrir
                      le CV
                    </p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Boutons d'action -->
            <div
              class="flex flex-col sm:flex-row gap-3 md:gap-4 justify-center"
            >
              <button
                @click="closeCvModal"
                class="px-4 md:px-6 py-2 md:py-3 bg-gray-700 hover:bg-gray-600 text-white rounded-lg font-medium transition-colors duration-200 cursor-pointer flex items-center justify-center gap-2 text-sm md:text-base"
              >
                <Icon name="fa:times" />
                Fermer
              </button>

              <a
                href="/amir-talbi-cv.pdf"
                download="amir-talbi-cv.pdf"
                class="px-4 md:px-6 py-2 md:py-3 bg-primary hover:bg-primary/80 text-white rounded-lg font-medium transition-all duration-200 hover:shadow-lg hover:shadow-primary/25 cursor-pointer flex items-center justify-center gap-2 text-sm md:text-base"
              >
                <Icon name="fa:download" />
                Télécharger
              </a>

              <a
                href="/amir-talbi-cv.pdf"
                target="_blank"
                rel="noopener noreferrer"
                class="px-4 md:px-6 py-2 md:py-3 bg-blue-600 hover:bg-blue-500 text-white rounded-lg font-medium transition-all duration-200 cursor-pointer flex items-center justify-center gap-2 text-sm md:text-base"
              >
                <Icon name="fa:external-link" />
                Ouvrir dans un nouvel onglet
              </a>
            </div>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed } from "vue";

// État de la modale CV
const showCvModal = ref(false);
const iframeError = ref(false);

// Détection mobile simple
const isMobile = ref(false);
onMounted(() => {
  isMobile.value =
    /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(
      navigator.userAgent
    );
});

// Fonctions pour gérer la modale
const openCvModal = () => {
  console.log("Opening CV modal"); // Debug
  showCvModal.value = true;
  iframeError.value = false; // Reset error state
  console.log("Modal state:", showCvModal.value); // Debug
  // Empêcher le scroll du body (seulement côté client)
  if (process.client) {
    document.body.style.overflow = "hidden";
  }
};

const closeCvModal = () => {
  console.log("Closing CV modal"); // Debug
  showCvModal.value = false;
  console.log("Modal state:", showCvModal.value); // Debug
  // Restaurer le scroll du body (seulement côté client)
  if (process.client) {
    document.body.style.overflow = "auto";
  }
};

const handleIframeError = () => {
  console.log("Iframe error, showing fallback");
  iframeError.value = true;
};

// Fermer la modale avec Escape (seulement côté client)
const handleKeydown = (event) => {
  if (event.key === "Escape" && showCvModal.value) {
    closeCvModal();
  }
};

onMounted(() => {
  if (process.client) {
    document.addEventListener("keydown", handleKeydown);
  }
});

onUnmounted(() => {
  if (process.client) {
    document.removeEventListener("keydown", handleKeydown);
    document.body.style.overflow = "auto";
  }
});

const projects = ref([
  {
    name: "Rent a Park",
    title: "Le Airbnb des places de parking",
    description:
      "Rent A Park est une plateforme web et mobile permettant aux particuliers de louer leurs places de parking à d'autres conducteurs. Elle intègre la géolocalisation, le paiement sécurisé, la gestion des disponibilités et un système d'évaluations. L'objectif : optimiser l'usage des parkings et simplifier la réservation d'une place.",
    image: "",
    technologies: ["Nuxt.js", "NestJS", "MongoDB", "Tailwind CSS"],
    link: "",
    finished: false,
  },
  {
    name: "GoVTC API",
    title: "API complète pour plateforme de transport VTC",
    description:
      "GoVTC API est une API robuste développée pour une plateforme de transport VTC. Elle gère l'authentification, la géolocalisation en temps réel, les réservations, les paiements et la communication entre chauffeurs et passagers via WebSockets. L'architecture modulaire avec NestJS permet une scalabilité optimale.",
    image: "",
    technologies: ["NestJS", "MongoDB", "Socket.io", "Docker", "JWT", "TypeScript"],
    link: "https://go-vtc.amirtalbi.me/",
    finished: true,
  },
  {
    name: "Webinnov Paris",
    title: "Un site vitrine pour une agence de développement web",
    description:
      "Le site vitrine de Webinnov Paris présente les services, les réalisations et l'expertise de l'équipe en développement web et mobile. Il offre un aperçu des projets menés, des compétences techniques et des méthodes de travail. Sa vocation : informer, rassurer et convaincre les prospects de collaborer avec Webinnov.",
    image: "/assets/webinnov.png",
    technologies: ["Nuxt.js", "Tailwind CSS"],
    link: "https://webinnov-paris.fr/",
    finished: true,
  },
  {
    name: "Morpion",
    title: "Jeu de morpion en ligne",
    description:
      "Un jeu de morpion en ligne permettant de jouer contre un ami. Il propose une interface simple et intuitive, avec des graphismes modernes et une expérience utilisateur fluide.",
    image: "",
    technologies: [
      "Vue.js",
      "Tailwind CSS",
      "Express.js",
      "Socket.io",
      "Docker",
    ],
    link: "https://github.com/amirtalbi/morpion-web-socket",
    finished: true,
  },
  {
    name: "GoMemories",
    title: "Une plateforme de partage de souvenirs",
    description:
      "GoMemories est une plateforme de partage de souvenirs qui permet aux utilisateurs de créer, partager et découvrir des moments mémorables.",
    image: "/assets/go-memories.png",
    technologies: ["Vue.js", "Tailwind CSS", "Express.js", "Minio", "Docker"],
    link: "",
    finished: true,
  },
]);

const skills = ref([
  {
    category: "Frontend",
    icon: "fa:code",
    color: "from-blue-400 to-blue-600",
    skills: [
      "Vue.js",
      "Nuxt.js",
      "JavaScript",
      "TypeScript",
      "HTML5",
      "CSS3",
      "Tailwind CSS",
    ],
  },
  {
    category: "Backend",
    icon: "fa:server",
    color: "from-green-400 to-green-600",
    skills: [
      "Node.js",
      "NestJS",
      "Express.js",
      "PHP",
      "Symfony",
      "API REST",
      "GraphQL",
    ],
  },
  {
    category: "DevOps",
    icon: "fa:cogs",
    color: "from-purple-400 to-purple-600",
    skills: [
      "Docker",
      "Docker Compose",
      "Git",
      "GitHub Actions",
      "Linux",
      "Nginx",
      "Apache",
    ],
  },
  {
    category: "Bases de données",
    icon: "fa:database",
    color: "from-orange-400 to-orange-600",
    skills: ["MongoDB", "MySQL", "PostgreSQL", "Redis", "Prisma", "Mongoose"],
  },
  {
    category: "Outils & Technologies",
    icon: "fa:wrench",
    color: "from-pink-400 to-pink-600",
    skills: ["VS Code", "Figma", "Postman", "Trello", "Minio", "Socket.io"],
  },
]);
</script>

<style scoped>
.animate-fade-in {
  animation: fadeIn 0.8s ease-in-out;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }

  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
