// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import DisplayChatController from "./display_chat_controller"
eagerLoadControllersFrom("controllers", application)
application.register("display-chat", DisplayChatController)
