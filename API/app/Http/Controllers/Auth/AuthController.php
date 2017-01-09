<?php

namespace App\Http\Controllers\Auth;

use App\User;
use Validator;
use Guard;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Tymon\JWTAuth\Exceptions\JWTException;
use Tymon\JWTAuth\Facades\JWTAuth;

class AuthController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | Registration & Login Controller
    |--------------------------------------------------------------------------
    |
    | This controller handles the registration of new users, as well as the
    | authentication of existing users. By default, this controller uses
    | a simple trait to add these behaviors. Why don't you explore it?
    |
    */

    protected $redirectTo = '/home';

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('guest', ['except' => 'logout']);
    }
    
    public function authenticate(Request $request){
        $credentials = $request::only('email', 'password');
        
        try{
            if($token = JWTAuth::attempt($credentials)) {
                return $this->response->error(['error' => 'Ingegeven wardes zijn niet correct'], 401);
            }
        }catch (JWTException $ex){
            return $this->response->error(['error' => 'Er ging iets fout'], 500);
        }
        
        return $this->response->array(compact('token'))->setStatusCode(200);
    }

    /**
     * Create a new user instance after a valid registration.
     *
     * @param  array  $data
     * @return User
     */
    protected function create(array $data)
    {
        return User::create([
            'name' => $data['name'],
            'email' => $data['email'],
            'password' => bcrypt($data['password']),
        ]);
    }
}